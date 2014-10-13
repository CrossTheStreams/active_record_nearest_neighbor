module ActiveRecord::Base::NearestNeighbor::Scopes

  def bounding_box_close_to(params)
    latitude = params[:latitude]
    longitude = params[:longitude]
    limit = params[:limit]

    # default of 10km
    distance = params[:distance] || 10000

    # If we have an object id, don't include the object in results
    not_id_subclause = params[:id] ? "id != #{params[:id]}" : ''

    where(%{ST_DWithin(points.lonlat, ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')::geometry, #{distance})}).
      where(not_id_subclause).
    order(%{ST_Distance(
      #{table_name}.lonlat,
      ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')::geometry
    )}).
    limit(params[:limit])
  end

  def k_nearest_neighbor_close_to(params)
    longitude = params[:longitude]
    latitude = params[:latitude]
    limit = params[:limit]  || 'NULL'
    # If we have an object id, don't include the object in results
    not_id_subclause = params[:id] ? "WHERE(id != #{params[:id]})" : ''

    find_by_sql(
       %{WITH closest_candidates AS (
          SELECT "#{table_name}".* FROM "#{table_name}"
          #{not_id_subclause}
          ORDER BY
            #{table_name}.lonlat::geometry <->
            ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')::geometry
        )
        SELECT *
        FROM closest_candidates
        ORDER BY
          ST_Distance(
            closest_candidates.lonlat,
            ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')::geometry
          )
        LIMIT #{limit};} 
    )
  end


end

