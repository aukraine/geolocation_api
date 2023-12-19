require 'swagger_helper'

RSpec.describe 'Geolocation API', type: :request, swagger_doc: 'v1/swagger.json' do
  let(:HTTP_AUTHORIZATION) { 'Bearer JWT' }
  let(:current_user) { FactoryBot.create(:user) }

  before { allow(JsonWebToken).to receive(:decode).and_return({ user_id: current_user.id }) }

  path '/api/v1/geolocations' do
    get 'gets geolocations' do
      tags 'Geolocation'
      description 'Returns list of all geolocations'
      produces 'application/json'

      before do
        create(:geolocation, :ipv4)
        create(:geolocation, :ipv6, :with_url)
      end

      response '200', 'geolocations list' do
        run_test!
      end

      response '401', 'unauthorized request' do
        before { allow(JsonWebToken).to receive(:decode).and_return(nil) }

        run_test!
      end

      response '403', 'forbidden action' do
        before { allow_any_instance_of(GeolocationPolicy).to receive(:index?).and_return(false) }

        run_test!
      end

      response '404', 'not found' do
        before { allow(JsonWebToken).to receive(:decode).and_return({ user_id: nil }) }

        run_test!
      end
    end

    post 'creates geolocation' do
      tags 'Geolocations'
      description 'Creates new geolocations data received from external service by given IP or URL'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :payload, in: :body, required: true, schema: {
        type: :object,
        properties: {
          target: { type: :string, format: 'ip' },
        },
        required: ['target']
      }, description: 'A payload JSON body used to used IP or URL value to search on external service'

      let(:payload) { { target: target } }
      let(:target) { '172.67.23.90' }
      let(:external_response) { instance_double('external_response', body: input.to_json, success?: true) }

      let(:input) do
        {
          'ip': '172.67.23.90',
          'type': 'ipv4',
          'continent_code': 'NA',
          'continent_name': 'North America',
          'country_code': 'US',
          'country_name': 'United States',
          'region_code': 'CA',
          'region_name': 'California',
          'city': 'San Francisco',
          'zip': '94107',
          'latitude': 37.76784896850586,
          'longitude': -122.39286041259766,
          'location': {
            'geoname_id': 5391959,
            'capital': 'Washington D.C.',
            'languages': [
              {
                'code': 'en',
                'name': 'English',
                'native': 'English'
              }
            ],
            'country_flag': 'https://assets.ipstack.com/flags/us.svg',
            'country_flag_emoji': '🇺🇸',
            'country_flag_emoji_unicode': 'U+1F1FA U+1F1F8',
            'calling_code': '1',
            'is_eu': false
          }
        }
      end

      before { allow_any_instance_of(Ipstack::GetData).to receive(:call).and_return(external_response) }

      response '201', 'geolocation created' do
        run_test!
      end

      response '400', 'bad request' do
        let(:input) { {} }

        run_test!
      end

      response '401', 'unauthorized request' do
        before { allow(JsonWebToken).to receive(:decode).and_return(nil) }

        run_test!
      end

      response '403', 'forbidden action' do
        before { allow_any_instance_of(GeolocationPolicy).to receive(:create?).and_return(false) }

        run_test!
      end

      response '404', 'not found' do
        before { allow(JsonWebToken).to receive(:decode).and_return({ user_id: nil }) }

        run_test!
      end

      response '421', 'misdirected request' do
        let(:input) { { detail: 'Not Found' } }

        run_test!
      end

      response '422', 'unprocessable params' do
        let(:target) { 'google.c' }

        run_test!
      end

      response '500', 'internal error' do
        before { allow_any_instance_of(Ipstack::GetData).to receive(:call).and_raise(ActiveModel::RangeError) }

        run_test!
      end

      response '502', 'bad gateway' do
        before { allow_any_instance_of(Ipstack::GetData).to receive(:call).and_raise(Faraday::Error) }

        run_test!
      end
    end
  end

  path '/api/v1/geolocations/{target}' do
    parameter name: :target,
              in: :path,
              schema: { type: :string, format: 'ip' },
              required: true,
              description: 'A parameter used to search by IP or URL value'

    let(:target) { ip }
    let(:ip) { Faker::Internet.ip_v4_address }

    before { create(:geolocation, ip: ip) }

    get 'gets geolocation' do
      tags 'Geolocations'
      description 'Returns geolocation by given IP or URL'
      produces 'application/json'

      response '200', 'geolocation resource' do
        run_test!
      end

      response '401', 'unauthorized request' do
        before { allow(JsonWebToken).to receive(:decode).and_return(nil) }

        run_test!
      end

      response '403', 'forbidden action' do
        before { allow_any_instance_of(GeolocationPolicy).to receive(:show?).and_return(false) }

        run_test!
      end

      response '404', 'not found' do
        let(:target) { Faker::Internet.ip_v6_address }

        run_test!
      end

      response '422', 'unprocessable params' do
        let(:target) { 'google' }

        run_test!
      end
    end

    delete 'deletes geolocation' do
      tags 'Geolocations'
      description 'Deletes geolocation by given IP or URL'
      produces 'application/json'

      response '200', 'geolocation deleted' do
        run_test!
      end

      response '401', 'unauthorized request' do
        before { allow(JsonWebToken).to receive(:decode).and_return(nil) }

        run_test!
      end

      response '403', 'forbidden action' do
        before { allow_any_instance_of(GeolocationPolicy).to receive(:destroy?).and_return(false) }

        run_test!
      end

      response '404', 'not found' do
        let(:target) { Faker::Internet.ip_v6_address }

        run_test!
      end

      response '422', 'unprocessable params' do
        let(:target) { 'google' }

        run_test!
      end
    end
  end
end
