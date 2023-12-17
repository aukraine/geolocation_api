RSpec.describe LatitudeValidator, type: :validator do
  subject { described_class.new.validate(record) }

  let(:record) { build(:geolocation, latitude: latitude) }

  before { subject }

  describe '#validate' do
    context 'when value is valid' do
      let(:latitude) { Faker::Address.latitude }

      it 'does not add any errors', :aggregate_failures do
        expect(record).to be_valid
        expect(record.errors).to be_empty
      end
    end

    describe 'when value is invalid' do
      context 'when value is absent' do
        let(:latitude) { nil }

        it 'adds expected error message', :aggregate_failures do
          expect(record).not_to be_valid
          expect(record.errors[:latitude]).to include('must be between -90 and 90')
        end
      end

      context 'when value is wrong format' do
        let(:latitude) { -100 }

        it 'adds expected error message', :aggregate_failures do
          expect(record).not_to be_valid
          expect(record.errors[:latitude]).to include('must be between -90 and 90')
        end
      end
    end
  end
end

