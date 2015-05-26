namespace :nearest_neighbor do
  desc "Create a new table with latitude, longitude, lonlat (point type), and a spatial index for lonlat" 
  task :create, [:table_name]  => :environment  do |task, args|
    timestamp  = Time.zone.now.strftime("%Y%m%d%H%M%S")
    table_name = args[:table_name]
    class_name = table_name.split("_").map(&:capitalize).join
    migration = 
%{class Create#{class_name} < ActiveRecord::Migration
  def change
    create_table :#{table_name} do |t|
      t.decimal :latitude,  precision: 9, scale: 6, null: false
      t.decimal :longitude, precision: 9, scale: 6, null: false
      t.point :lonlat, :geographic => true
      t.index :lonlat, :spatial => true
    end
  end
end}
    file_name = "./db/migrate/#{timestamp}_create_#{table_name}.rb"
    file = File.open(file_name,"w+")
    file.write(migration)
    file.close
    puts "generated migration: #{file_name}"
  end

  desc "Add columns to existing table: latitude, longitude, lonlat (point type), and a spatial index for lonlat" 
  task :add_columns, [:table_name]  => :environment do |task, args|
    timestamp  = Time.zone.now.strftime("%Y%m%d%H%M%S")
    table_name = args[:table_name]
    class_name = table_name.split("_").map(&:capitalize).join
    migration = 
%{class AddGeospatialColumnsTo#{class_name} < ActiveRecord::Migration
  def change
    add_column :#{table_name}, :latitude, :decimal, precision: 9, scale: 6, null: false
    add_column :#{table_name}, :longitude, :decimal, precision: 9, scale: 6, null: false
    add_column :#{table_name}, :lonlat, :point, geographic: true
    add_index :#{table_name}, :lonlat, spatial: true
  end
end}
    file_name = "db/migrate/#{timestamp}_add_geospatial_columns_to_#{table_name}.rb"
    file = File.open(file_name,"w+")
    file.write(migration)
    file.close
    puts "generated migration: #{file_name}"
  end

end
