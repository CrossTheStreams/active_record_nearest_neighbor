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
  s.summary     = "A Rails/ActiveRecord plugin to easily add nearest neighbor geospatial queries with PostGIS and PostgreSQL."
  s.description = "ActiveRecordNearestNeighbor adds methods to your ActiveRecord models to perform nearest neighbor searches, using different algorithms. The plugin also provides a rake task for generating migrations to add geospatial columns and indexes to your models."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", "~> 4.1.0"
  s.add_dependency "activesupport", "~> 4.1.0"
  s.add_dependency 'activerecord-postgis-adapter'

end
