module ActiveRecord::Base::NearestNeighbor::CloseTo

  def close_to(longitude_or_object, longitude_or_latitude_or_options={}, options={})
    scope_method = :bounding_box
    scope_params = {}

    if longitude_or_object.class.ancestors.include?(ActiveRecord::Base)  
      # We are using an object as the point reference
      object = longitude_or_object
      options = longitude_or_latitude_or_options

      scope_method = options[:method] || scope_method
      scope_params = {id: options[:id], distance: options[:distance], limit: options[:limit]}.
      merge(longitude: object.longitude, latitude: object.latitude, id: object.id)
    else
      # We are using longitude and latitude
      longitude = longitude_or_object
      latitude = longitude_or_latitude_or_options

      scope_method = options[:method] || scope_method

      scope_params = {id: options[:id], distance: options[:distance], limit: options[:limit]}.
      merge(longitude: longitude, latitude: latitude)
    end

    close_to_with_scope(scope_method, scope_params)
  end

  private

  def close_to_with_scope(scope_method, params={})
    scope = "#{scope_method}_close_to".to_sym
    self.send(scope,params) 
  end

end
