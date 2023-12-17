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

    add_index :geolocations, :ip
    add_index :geolocations, :url, where: 'url IS NOT NULL'
  end
end
