require 'active_support'
require 'active_record'
require 'active_record_nearest_neighbor/railtie' if defined?(Rails)

class ActiveRecord::Base

  module NearestNeighbor

    require 'active_record_nearest_neighbor/scopes'
    require 'active_record_nearest_neighbor/close_to'

    extend ActiveSupport::Concern

    included do

      # ensure the lonlat attribute
      before_save :set_lonlat!

    end

    module ClassMethods
      extend ActiveSupport::Concern
      
      include Scopes
      include CloseTo

    end

    private

    def set_lonlat!
      self.lonlat = "POINT(#{self.longitude} #{self.latitude})"
    end
    
  end
end
