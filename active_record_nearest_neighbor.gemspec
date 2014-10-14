$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_record_nearest_neighbor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_record_nearest_neighbor"
  s.version     = ActiveRecordNearestNeighbor::VERSION
  s.authors     = ["Andrew Hautau"]
  s.email       = ["arhautau@gmail.com"]
  s.homepage    = "https://github.com/CrossTheStreams/active_record_nearest_neighbor"
  s.summary     = "A Rails/Active Record plugin to easily add nearest neighbor geospatial queries with PostGIS and PostgreSQL."
  s.description = "Adds scopes to your models to perform nearest neighbor queries with PostGIS and PostgreSQL. Also provides rake tasks for generating migrations to create geospatial tables or add geospatial columns and indexes to your existing tables."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", '~> 4.1'
  s.add_dependency "activesupport", '~> 4.1'
  s.add_dependency 'activerecord-postgis-adapter', '~> 2.2'

end
