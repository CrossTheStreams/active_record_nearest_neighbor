module ActiveRecord::Base::NearestNeighbor::Scopes
  def bounding_box_close_to(params)
    where(%{
      ST_DWithin(
        #{self.table_name}.lonlat,
        ST_GeographyFromText('SRID=4326;POINT(%f %f)'),
          %d
      ) 
    } % [params[:longitude], params[:latitude], params[:distance]])
  end

  def k_nearest_neighbor_close_to(params)
    order(%{
      ST_GeographyFromText('SRID=4326;POINT('|| #{self.table_name}.longitude || ' ' || #{self.table_name}.latitude || ')')::geometry <-> ST_GeographyFromText('SRID=4326;POINT(%f %f)')::geometry
    } % [params[:longitude], params[:latitude]])
  end
end

