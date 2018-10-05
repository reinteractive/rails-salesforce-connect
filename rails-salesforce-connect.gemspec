# gem 'activerecord'
Gem::Specification.new do |s|
  s.name        = 'rails-salesforce-connect'
  s.version     = '0.0.7'
  s.licenses    = ['MIT']
  s.summary     = "Tools for using heroku connect with rails"
  s.description = "Base class for salesforce migrations, activerecord types; deduplication rules aware, and rake tasks to sync schema"
  s.authors     = ["Daniel Heath"]
  s.email       = 'daniel@heath.cc'
  s.files       = `git ls-files`.lines.map( &:strip)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.homepage    = 'https://github.com/reinteractive/rails-salesforce-connect'
  s.metadata    = { "source_code_uri" => "https://github.com/reinteractive/rails-salesforce-connect" }
  s.add_runtime_dependency "activerecord"
  s.add_runtime_dependency "rake"
  s.add_runtime_dependency "pg"
  s.add_runtime_dependency "dotenv"
  s.add_runtime_dependency "hashdiff"
  s.add_runtime_dependency "restforce"
end
