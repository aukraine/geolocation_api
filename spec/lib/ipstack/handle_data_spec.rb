RSpec.describe Ipstack::HandleData, type: :lib do
  subject { described_class.new(instance_double('input', body: input.to_json, success?: success)) }

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

  let(:success) { true }

  describe '#transform' do
    let(:output) do
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

    before do
      allow(JSON).to receive(:parse).and_return(input)
    end

    it 'parses JSON' do
      expect(JSON).to receive(:parse).with(input.to_json, symbolize_names: true)
      subject.transform
    end

    it 'transforms data' do
      expect(subject.transform).to eq(output)
    end
    
    context 'when input data is invalid' do
      let(:input) do
        {
          success: false,
          error: {
            info: error_message
          }
        }
      end

      let(:error_message) { 'Foo bar' }

      it 'raises expected error' do
        expect { subject.transform }.to raise_exception(Errors::MisdirectedRequest) do |exception|
          expect(exception.errors).to include(error_message)
        end
      end

      context 'when response from external service is not success' do
        let(:success) { false }

        let(:error_message) { 'Not success response from external service' }

        it 'raises expected error' do
          expect { subject.transform }.to raise_exception(Errors::MisdirectedRequest) do |exception|
            expect(exception.errors).to include(error_message)
          end
        end
      end

      context 'when input is edge case format' do
        let(:input) { { detail: 'Not Found' } }
        let(:error_message) { 'External service could not process URL with any prefixes' }

        it 'raises expected error' do
          expect { subject.transform }.to raise_exception(Errors::MisdirectedRequest) do |exception|
            expect(exception.errors).to include(error_message)
          end
        end
      end
    end
  end
end
