# Active Record Nearest Neighbor

Easy, high performance geospatial nearest-neighbor searches with ActiveRecord, leveraging PostGIS.

Dependencies:

1. [PostgreSQL](http://www.postgresql.org/).

2. [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord).

3. [PostGIS ActiveRecord Adapter gem](https://github.com/rgeo/activerecord-postgis-adapter).

In your Gemfile:

```
  gem 'active_record_nearest_neighbor'
```

The central feature of this gem is a scope method for your Active Record models, `close_to`. With `close_to`, you can perform blazing fast and accurate nearest neighbor searches with PostGIS, without writing a line of geospatial SQL. All you need to do is add the appropriate geospatial columns, include a module, and you're set:

Active Record Nearest Neighbor provides you with several helpful rake tasks to get you started:

1. If you don't yet have the PostGIS extension added to your PostgreSQL database:

  ```
    rake db:gis:setup
  ```

2. In your config/database.yml file, change the adapater of your database to postgis:

    ```
      database: postgis
    ```

3. Generate a rake task to create a table or add columns:

  1. To generate a migration to create a new table with geospatial columns:

    ```
      rake nearest_neighbor:create[table_name]
    ```

  2. To generate a migration to add geospatial columns and point index to a table that you already have:

    ```
      rake nearest_neighbor:add_columns[table_name]
    ```

4. Run the generated migration with `$ rake db:migrate`

5. To add `close_by` to your model class, include `NearestNeighbor`:

  ```
     class Building < ActiveRecord::Base
       include NearestNeighbor

     end
  ```

6. Now you're set!

  ```
    # Buildings close to the Empire State Building
    latitude = 40.748441
    longitude = -73.985664
    Building.close_to(longitude, latitude)
  ```

You can use `close_to` in different ways to perform the nearest neighbor query that you want. By default, `close_to` will use a bounding box of 10 kilometers. Set the `:distance` option (uses meters) if you want to change the size of this bounding box.


  ```
    # Buildings within 500 meters from the Empire State Building
    latitude = 40.748441
    longitude = -73.985664
    Building.close_to(longitude, latitude, distance: 500)
  ```

If you want to know what's close to your geospatial Active Record objects, simply pass the object to `close_to` instead of longitude and latitude!

  ```
    # Buildings within 500 meters from the Space Needle 
    space_needle = Building.find_by_name("Space Needle")
    Building.close_to(space_needle, distance: 500)
  ```

Maybe you need to avoid a bounding box? No sweat! Provide the `:k_nearest_neighbor` option to `close_to` and `close_to` will avoid a bounding box. This is great for nearest neighbor searches with data of greatly varying distances and/or datasets that aren't significantly large. NOTE: This will have slower performance with larger datasets.

  ```
    # Volcanoes, ordered by proximity to Mount Rainier 
    mount_rainier = Volcanoe.find_by_name("Mount Rainier")
    Volcano.close_to(mount_rainier, method: :k_nearest_neighbor)
  ```

You can provide `close_to` with a `limit` option if you know a limit ahead of time:

  ```
    # The 5 closest roller coasters to Los Angeles 
    RollerCoaster.close_to(-118.243685, 34.052234, method: :k_nearest_neighbor, limit: 5)
  ```
