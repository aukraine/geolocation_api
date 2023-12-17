RSpec.describe LongitudeValidator, type: :validator do
  subject { described_class.new.validate(record) }

  let(:record) { build(:geolocation, longitude: longitude) }

  before { subject }

  describe '#validate' do
    context 'when value is valid' do
      let(:longitude) { Faker::Address.longitude }

      it 'does not add any errors', :aggregate_failures do
        expect(record).to be_valid
        expect(record.errors).to be_empty
      end
    end

    describe 'when value is invalid' do
      context 'when value is absent' do
        let(:longitude) { nil }

        it 'adds expected error message', :aggregate_failures do
          expect(record).not_to be_valid
          expect(record.errors[:longitude]).to include('must be between -180 and 180')
        end
      end

      context 'when value is wrong format' do
        let(:longitude) { 181.333333 }

        it 'adds expected error message', :aggregate_failures do
          expect(record).not_to be_valid
          expect(record.errors[:longitude]).to include('must be between -180 and 180')
        end
      end
    end
  end
end
