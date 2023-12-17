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
require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  describe 'validations' do
    before { create(:geolocation) }

    it { is_expected.to validate_presence_of(:ip) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
  end
end
