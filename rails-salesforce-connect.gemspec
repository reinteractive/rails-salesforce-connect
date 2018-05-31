# gem 'activerecord'
Gem::Specification.new do |s|
  s.name        = 'rails-salesforce-connect'
  s.version     = '0.0.1'
  s.licenses    = ['MIT']
  s.summary     = "Tools for using heroku connect with rails"
  s.description = "Base class for salesforce migrations, activerecord types; deduplication rules aware, and rake tasks to sync schema"
  s.authors     = ["Daniel Heath"]
  s.email       = 'daniel@heath.cc'
  s.files       = `git ls-files`.lines.map( &:strip)
  s.homepage    = 'https://github.com/reinteractive/rails-salesforce-connect'
  s.metadata    = { "source_code_uri" => "https://github.com/reinteractive/rails-salesforce-connect" }
  s.add_runtime_dependency "activerecord", '~> 0'
  s.add_runtime_dependency "rake", '~> 0'
  s.add_runtime_dependency "pg", '~> 0'
end
