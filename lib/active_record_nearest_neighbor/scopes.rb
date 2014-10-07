module ActiveRecord::Base::NearestNeighbor::Scopes

  def bounding_box_close_to(params)
    latitude = params[:latitude]
    longitude = params[:longitude]

    # default of 10km
    distance = params[:distance] || 10000

    where(%{ST_DWithin(points.lonlat, ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')::geometry, #{distance})}).
    order(%{ST_Distance(
      #{table_name}.lonlat,
      ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')::geometry
    );})
  end

  def k_nearest_neighbor_close_to(params)
    longitude = params[:longitude]
    latitude = params[:latitude]
    limit = params[:limit]  || 'NULL'

    find_by_sql(
       %{WITH closest_candidates AS (
          SELECT "#{table_name}".* FROM "#{table_name}"
          ORDER BY
            #{table_name}.lonlat::geometry <->
            ST_GeographyFromText('SRID=4326;POINT(#{longitude} #{latitude})')::geometry
          LIMIT #{limit}
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

