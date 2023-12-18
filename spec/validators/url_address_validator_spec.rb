RSpec.describe UrlAddressValidator, type: :validator do
  subject { described_class.new.validate(record) }

  let(:record) { build(:geolocation, url: url) }

  before { subject }

  describe '#validate' do
    context 'when value is valid' do
      context 'when value is present' do
        context 'when value is URL address' do
          let(:url) { Faker::Internet.url }

          it 'does not add any errors', :aggregate_failures do
            expect(record).to be_valid
            expect(record.errors).to be_empty
          end
        end


        context 'when value is domain address' do
          let(:url) { Faker::Internet.domain_name(subdomain: true) }

          it 'does not add any errors', :aggregate_failures do
            expect(record).to be_valid
            expect(record.errors).to be_empty
          end
        end
      end

      context 'when value is absent' do
        let(:url) { nil }

        it 'does not add any errors', :aggregate_failures do
          expect(record).to be_valid
          expect(record.errors).to be_empty
        end
      end
    end

    describe 'when value is invalid' do
      context 'when value is wrong format' do
        let(:url) { 'google.c' }

        it 'adds expected error message', :aggregate_failures do
          expect(record).not_to be_valid
          expect(record.errors[:url]).to include('Invalid URL format')
        end
      end
    end
  end
end
