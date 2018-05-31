class Connect::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/diff_schema.rake'
  end
end