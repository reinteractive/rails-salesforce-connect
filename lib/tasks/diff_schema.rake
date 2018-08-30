namespace :db do
  desc "Identify differences from your schema"
  task :dif_schema, [:remote_connection_string] => [:environment] do |task, args|
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

    remote_conn = args[:remote_connection_string] || ENV["HC_URL"] || ENV["HEROKUCONNECT_URL"] || fail(<<-MSG)
      Must specify remote_connection_string or provide ENV[HC_URL].
      Try
        export HC_URL="$(heroku config:get DATABASE_URL)"

    MSG
    remote = PG::Connection.new(remote_conn).async_exec(sql).each.to_a
    local = ApplicationRecord.connection.raw_connection.async_exec(sql).each.to_a

    remote.each {|c| c["character_maximum_length"] = c["character_maximum_length"].to_i }
    local.each {|c| c["character_maximum_length"] = c["character_maximum_length"].to_i }

    def format_column(c)
      nul = (c["is_nullable"] == "YES")
      length = c["character_maximum_length"] ? ", limit: #{c["character_maximum_length"]}" : ""
      precision = c["numeric_precision"] ? ", precision: #{c["numeric_precision"]}" : ""
      "_column :#{c["table_name"]}, :#{c["column_name"]}, #{c["data_type"].inspect}, null: #{nul.to_s} #{length} #{precision}"
    end

    local = local.map &method(:format_column)
    remote = remote.map &method(:format_column)

    if (local - remote).any?
      puts "***************************************************"
      puts "**      Extra columns locally not in remote      **"
      puts "***************************************************"
      (local - remote).each do |c|
        puts "remove" + c
      end

    end

    if (remote - local).any?
      puts "***************************************************"
      puts "** Extra columns on remote not available locally **"
      puts "***************************************************"
      (remote - local).each do |c|
        puts "add" + c
      end
    end

    abort "Differences found" if (local - remote).any? or (remote - local).any?
  end
end
