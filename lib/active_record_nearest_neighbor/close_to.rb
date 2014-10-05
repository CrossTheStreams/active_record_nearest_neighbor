module ActiveRecord::Base::NearestNeighbor::CloseTo

  def close_to(longitude_or_object, longitude_or_latitude_or_options={}, options={})
    if longitude_or_object.class.ancestors.include?(ActiveRecord::Base)  
      # We are using an object as the point reference
      object = longitude_or_object
      options = longitude_or_latitude_or_options
      method = options[:method] || :bounding_box
      close_to_with_object(method, object, options)
    else
      # We are using longitude and latitude
      longitude = longitude_or_object
      latitude = longitude_or_latitude_or_options
      method = options[:method] || :bounding_box

      close_to_with_longitude_and_latitude(method, longitude, latitude, options) 
    end
  end

  private

  def close_to_with_object(scope_method, object, options={})
    scope = "#{scope_method}_close_to".to_sym
    params = options.merge(latitude: object.latitude, longitude: object.longitude)
    self.send(scope,params) 
  end

  def close_to_with_longitude_and_latitude(scope_method, longitude, latitude, options={})
    scope = "#{scope_method}_close_to".to_sym
    params = options.merge(longitude: longitude, latitude: latitude)
    self.send(scope,params)
  end


end
