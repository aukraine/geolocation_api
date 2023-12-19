RSpec.describe StoreGeolocation, type: :service do
  subject { described_class.new(target: target, _user: anything).call }

  describe 'behaviour' do
    let(:raw_data) do
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

    let(:transformed_data) do
      {
        'ip': '172.67.23.90',
        'type': 'ipv4',
        'latitude': 37.76784896850586,
        'longitude': -122.39286041259766,
        'location': {
          'continent_code': 'NA',
          'continent_name': 'North America',
          'country_code': 'US',
          'country_name': 'United States',
          'region_code': 'CA',
          'region_name': 'California',
          'city': 'San Francisco',
          'zip': '94107',
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

    let(:ip) { '172.67.23.90' }
    let(:url) { 'nv.ua' }
    let(:target) { ip }
    let(:geolocation) { create(:geolocation, ip: ip, url: url) }
    let(:external_response) { instance_double('response', body: raw_data) }

    before do
      allow_any_instance_of(Ipstack::GetData).to receive(:call).with(target).and_return(external_response)
      allow_any_instance_of(Ipstack::HandleData).to receive(:transform).and_return(transformed_data)
    end

    describe 'verifying of presence record in DB' do
      context 'when target is IP' do
        let(:target) { ip }

        context 'when record is already present' do
          before { geolocation }

          it 'returns failure result' do
            expect(subject[:success]).to eq(false)
          end

          it 'result contains error object', :aggregate_failures do
            expect(subject[:error]).to be_a(ActiveRecord::RecordNotUnique)
            expect(subject[:error].message).to eq('Geolocation is already exists')
          end
        end

        context 'when record is not present' do
          it 'returns success result' do
            expect(subject[:success]).to eq(true)
          end
        end
      end

      context 'when target is URL' do
        let(:target) { url }

        context 'when record is already present but without URL value' do
          let!(:geolocation) { create(:geolocation, ip: ip) }

          before { allow(Geolocation).to receive(:find_by).with(ip: transformed_data[:ip]).and_return(geolocation) }

          it 'updates URL record value' do
            expect { subject }.to change(geolocation, :url).from(nil).to(url)
          end

          it 'result contains error object', :aggregate_failures do
            expect(subject[:error]).to be_a(ActiveRecord::RecordNotUnique)
            expect(subject[:error].message).to eq('Geolocation is already exists')
          end
        end

        context 'when record is not present' do
          it 'returns success result', :aggregate_failures do
            expect(subject[:success]).to eq(true)
            expect(subject[:value]).to be_a(Geolocation)
          end

          it 'creates new record' do
            expect { subject }.to change(Geolocation, :count).by(1)
          end

          context 'when geo data is invalid' do
            let(:transformed_data) { {} }

            let(:errors) do
              [
                'Ip Invalid IP address format',
                "Ip can't be blank",
                "Type can't be blank",
                'Latitude must be between -90 and 90',
                "Latitude can't be blank",
                'Longitude must be between -180 and 180',
                "Longitude can't be blank"
              ]
            end

            it 'returns failure result' do
              expect(subject[:success]).to eq(false)
            end

            it 'result contains error object', :aggregate_failures do
              expect(subject[:error]).to be_a(Errors::BadRequest)
              expect(subject[:error].errors).to match_array(errors)
            end
          end
        end
      end
    end
  end
end
