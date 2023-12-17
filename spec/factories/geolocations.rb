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
FactoryBot.define do
  factory :geolocation do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    ipv4

    trait :ipv4 do
      ip { Faker::Internet.ip_v4_address }
      type { 'ipv4' }
    end

    trait :ipv6 do
      ip { Faker::Internet.ip_v6_address }
      type { 'ipv6' }
    end

    trait :with_url do
      url { Faker::Internet.url }
    end

    trait :with_jsonb_location do
      location do
        {
          continent_code: 'NA',
          continent_name: 'North America',
          country_code: 'US',
          country_name: 'United States',
          region_code: 'CA',
          region_name: 'California',
          city: 'Mountain View',
          zip: '94043',
          geoname_id: 5375480,
          capital: 'Washington D.C.',
          languages: [
            {
              code: 'en',
              name: 'English',
              native: 'English'
            }
          ],
          country_flag: 'https://assets.ipstack.com/flags/us.svg',
          country_flag_emoji: '🇺🇸',
          country_flag_emoji_unicode: 'U+1F1FA U+1F1F8',
          calling_code: '1',
          is_eu: false
        }
      end
    end
  end
end
