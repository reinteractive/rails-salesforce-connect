# gem 'activerecord'
Gem::Specification.new do |s|
  s.name        = 'rails-salesforce-connect'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = "Tools for using heroku connect with rails"
  s.description = "Base class for salesforce migrations, activerecord types; deduplication rules aware, and rake tasks to sync schema"
  s.authors     = ["Daniel Heath"]
  s.email       = 'daniel@heath.cc'
  s.files       = ["lib/rails-salesforce-connect.rb"]
  s.homepage    = 'https://github.com/reinteractive'
  s.metadata    = { "source_code_uri" => "https://github.com/reinteractive" }
  s.add_runtime_dependency "activerecord"
  s.add_runtime_dependency "rake"
end
