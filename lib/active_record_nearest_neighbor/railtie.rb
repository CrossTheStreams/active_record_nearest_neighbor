require 'active_record/connection_adapters/postgis_adapter'

module ActiveRecordNearestNeighbor

  class Railtie < Rails::Railtie

    rake_tasks do
      load 'tasks/active_record_nearest_neighbor_tasks.rake'
      load 'active_record/connection_adapters/postgis_adapter/databases.rake'
    end

  end



end

