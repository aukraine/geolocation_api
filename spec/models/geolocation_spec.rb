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

  describe 'scopes' do
    describe '#find_by_ip_or_url' do
      let(:ipv4) { Faker::Internet.ip_v4_address }
      let(:ipv6) { Faker::Internet.ip_v6_address }
      let(:url) { Faker::Internet.url }
      let(:domain) { Faker::Internet.domain_name }

      before { create_pair(:geolocation) }

      context 'when expected record contain only IP value' do
        let!(:record_1) { create(:geolocation, ip: ipv4, url: nil) }
        let!(:record_2) { create(:geolocation, ip: ipv6, url: nil) }

        it 'return expected record', :aggregate_failures do
          expect(described_class.find_by_ip_or_url(ipv4)).to contain_exactly(record_1)
          expect(described_class.find_by_ip_or_url(ipv6)).to contain_exactly(record_2)
        end
      end

      context 'when expected record contain IP and URL values' do
        let!(:record_1) { create(:geolocation, ip: ipv4, url: url) }
        let!(:record_2) { create(:geolocation, ip: ipv6, url: domain) }

        it 'return expected record', :aggregate_failures do
          expect(described_class.find_by_ip_or_url(url)).to contain_exactly(record_1)
          expect(described_class.find_by_ip_or_url(ipv4)).to contain_exactly(record_1)
          expect(described_class.find_by_ip_or_url(domain)).to contain_exactly(record_2)
          expect(described_class.find_by_ip_or_url(ipv6)).to contain_exactly(record_2)
        end
      end
    end
  end
end
