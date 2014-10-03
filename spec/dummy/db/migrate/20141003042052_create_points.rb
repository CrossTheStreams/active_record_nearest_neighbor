class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.decimal :latitude,  precision: 9, scale: 6, null: false
      t.decimal :longitude, precision: 9, scale: 6, null: false
      t.point :lonlat, :geographic => true
      t.index :lonlat, :spatial => true
    end
  end
end
