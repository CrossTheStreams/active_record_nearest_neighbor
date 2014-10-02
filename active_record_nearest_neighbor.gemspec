$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_record_nearest_neighbor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_record_nearest_neighbor"
  s.version     = ActiveRecordNearestNeighbor::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ActiveRecordNearestNeighbor."
  s.description = "TODO: Description of ActiveRecordNearestNeighbor."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "pg"
end
