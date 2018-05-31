namespace :db do
  desc "Identify differences from your schema"
  task :diff_schema, [:remote_connection_string] => [:environment] do |task, args|
    require 'pg'

    sql = <<-SQL
      select
        table_name,
        column_name,
        is_nullable,
        data_type,
        character_maximum_length,
        numeric_precision
      from
        information_schema.columns
      where
        table_schema = 'salesforce' and
        table_name != '_trigger_log_archive' and
        table_name != '_trigger_log' and
        table_name != '_sf_event_log' and
        table_name != '_hcmeta'
      order by
        table_name,
        ordinal_position
      ;
    SQL

    remote_conn = args[:remote_connection_string] || ENV["HC_URL"] || fail(<<-MSG)
      Must specify remote_connection_string or provide ENV[HC_URL].
      Try
        export HC_URL="$(heroku config:get DATABASE_URL)"

    MSG
    remote = PG::Connection.new(args[:remote_connection_string] || ENV["HC_URL"]).async_exec(sql).each.to_a
    local = ApplicationRecord.connection.raw_connection.async_exec(sql).each.to_a

    local.each do |column|
      # Remove if it exists
      if remote.delete(column)
        # Same column exists in both.
        local.delete(column)
        next
      end
    end

    if local.any?
      puts "***************************************************"
      puts "**      Extra columns locally not in remote      **"
      puts "***************************************************"
      local.each do |c|
        nul = (c["is_nullable"] == "YES")
        length = c["character_maximum_length"] ? ", length: #{c["character_maximum_length"]}" : ""
        precision = c["numeric_precision"] ? ", precision: #{c["numeric_precision"]}" : ""
        puts "remove_column :#{c["table_name"]}, :#{c["column_name"]}, #{c["data_type"].inspect}, null: #{nul.to_s}#{length}#{precision}"
      end

    end

    if remote.any?
      puts "***************************************************"
      puts "** Extra columns on remote not available locally **"
      puts "***************************************************"
      remote.each do |c|
        nul = (c["is_nullable"] == "YES")
        length = c["character_maximum_length"] ? ", length: #{c["character_maximum_length"]}" : ""
        precision = c["numeric_precision"] ? ", precision: #{c["numeric_precision"]}" : ""
        puts "add_column :#{c["table_name"]}, :#{c["column_name"]}, #{c["data_type"].inspect}, null: #{nul.to_s} #{length} #{precision}"
      end
    end
    abort "Differences found" if local.any? or remote.any?
  end
end
