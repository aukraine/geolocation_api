# == Schema Information
#
# Table name: geolocations
#
#  id         :bigint           not null, primary key
#  ip         :string           not null
#  latitude   :float            not null
#  location   :jsonb            not null
#  longitude  :float            not null
#  type       :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Geolocation < ApplicationRecord
end
