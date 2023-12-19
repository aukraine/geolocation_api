class ChangeExistingIndexToUniqueOnGeolocationIp < ActiveRecord::Migration[7.1]
  def up
    remove_index :geolocations, :ip
    add_index :geolocations, :ip, unique: true
  end

  def down
    remove_index :geolocations, :ip
    add_index :geolocations, :ip
  end
end
