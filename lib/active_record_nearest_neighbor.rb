require 'active_record'
require 'active_record_nearest_neighbor/railtie' if defined?(Rails)

module ActiveRecordNearestNeighbor
  extend ActiveSupport::Concern

  include do

    scope :bounding_box_close_to, lambda { |params|
      where(%{
        ST_DWithin(
          #{self.table_name}.geom,
          ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
            %d
        ) 
      } % [params[:longitude], params[:latitude], params[:distance_in_meters]])
    }

    scope :k_nearest_neighbor_close_to, lambda { |params|
      order(%{
          ST_GeographyFromText('SRID=4326;POINT('|| #{self.table_name}.longitude || ' ' || #{self.table_name}.latitude || ')')::geometry <-> ST_GeographyFromText('SRID=4326;POINT(%f %f)')::geometry
      } % [params[:longitude], params[:latitude]])
    }

    # ensure the geom attribute
    before_save do
      self.geom = "POINT(#{self.longitude} #{self.latitude})"
    end

  end

  module ClassMethods

    def close_to(longitude, latitude, options={})
      method = options[:method] || :bounding_box
      scope = "#{options[:method]}_close_to".to_sym

      options[:longitude] = longitude
      options[:latitude] = latitude

      self.send(scope,options)
    end

  end

end
