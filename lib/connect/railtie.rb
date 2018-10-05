# frozen_string_literal: true
class Connect::Railtie < Rails::Railtie
  rake_tasks do
    path = File.dirname(File.dirname(__FILE__))
    load "#{path}/tasks/diff_schema.rake"
    load "#{path}/tasks/diff_salesforce.rake"
  end
end
