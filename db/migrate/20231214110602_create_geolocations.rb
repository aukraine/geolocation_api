class CreateGeolocations < ActiveRecord::Migration[7.1]
  def change
    create_table :geolocations do |t|
      t.string :ip, null: false
      t.string :url, null: true
      t.string :type, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.jsonb :location, default: {}, null: false

      t.timestamps
    end
  end
end
