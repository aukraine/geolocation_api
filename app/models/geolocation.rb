# == Schema Information
#
# Table name: geolocations
#
#  id         :bigint           not null, primary key
#  ip         :string           not null
#  latitude   :float            not null
#  location   :jsonb            not null, default({})
#  longitude  :float            not null
#  type       :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_geolocations_on_ip   (ip)
#  index_geolocations_on_url  (url) WHERE (url IS NOT NULL)
#
class Geolocation < ApplicationRecord
  # disable STI that uses 'type' attribute as we have it included in Geospatial data
  self.inheritance_column = :_type

  validates :ip, ip_address: true, presence: true
  validates :url, url_address: true
  validates :type, presence: true
  validates :latitude, latitude: true, presence: true
  validates :longitude, longitude: true, presence: true

  scope :find_by_ip_or_url, ->(target) { where(ip: target).or(where(url: target)) }
end
