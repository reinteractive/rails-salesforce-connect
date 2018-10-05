# frozen_string_literal: true
require 'json'
require 'bundler'
require 'hashdiff'
Bundler.require
namespace :salesforce do

  namespace :schema do
    desc "Save the salesforce schema for the given app"
    task :dump, [:app_name] do |_t, args|
      env = ENV
      outfile = 'salesforce-schema.json'

      if args[:app_name] && args[:app_name].length > 0
        require 'dotenv'
        env = Dotenv::Parser.call(`heroku config --app #{args[:app_name]} --shell`)
        raise "Error fetching heroku config for #{args[:app_name]}" unless $?.success?
        outfile = "salesforce-schema-#{args[:app_name]}.json"
      end
      outfile = ENV.fetch("SCHEMA_FILE", outfile)

      require 'connect/api_adapter'
      description = Connect::ApiAdapter.describe(env).group_by {|e| e["name"] }
      description.each do |k, v|
        raise "Expected name to be unique" unless v.one?
        description[k] = v.first
        description[k].delete("name")
      end
      File.write(
        outfile,
        JSON.pretty_generate(description)
      )
    end

    desc "Diff two schema files against one another"
    task :diff, [:old, :new] do |_t, args|
      old_h = JSON.parse(File.read(args[:old]))
      new_h = JSON.parse(File.read(args[:new]))

      removed = old_h.keys - new_h.keys
      added = new_h.keys - old_h.keys
      diff = false
      removed.each do |r|
        puts "Removed object: #{r}"
        diff = true
      end
      added.each do |a|
        puts "Added object: #{a}"
        diff = true
      end

      removed.each {|k| old_h.delete(k)}
      added.each {|k| new_h.delete(k)}

      HashDiff.diff(old_h, new_h).each do |sym, key, old, new_val|
        diff = true
        case sym
        when "~"
          puts "Changed #{key} from #{old} to #{new_val}"
        when "-"
          puts "Removed #{key}"
        when "+"
          puts "Added #{key} = #{old}"
        else
          raise "Unknown HashDiff symbol '#{sym}', expected one of '~', '+' or '-'."
        end
      end

      exit(1) if diff
    end
  end
end
