RSpec.describe IpAddressValidator, type: :validator do
  subject { described_class.new.validate(record) }

  let(:record) { build(:geolocation, ip: ip) }

  before { subject }

  describe '#validate' do
    context 'when value is valid' do
      context 'when value is IPv4 format' do
        let(:ip) { Faker::Internet.ip_v4_address }

        it 'does not add any errors', :aggregate_failures do
          expect(record).to be_valid
          expect(record.errors).to be_empty
        end
      end

      context 'when value is IPv6 format' do
        let(:ip) { Faker::Internet.ip_v6_address }

        it 'does not add any errors', :aggregate_failures do
          expect(record).to be_valid
          expect(record.errors).to be_empty
        end
      end
    end

    describe 'when value is invalid' do
      context 'when value is absent' do
        let(:ip) { nil }

        it 'adds expected error message', :aggregate_failures do
          expect(record).not_to be_valid
          expect(record.errors[:ip]).to include('Invalid IP address format')
        end
      end

      context 'when value is wrong format' do
        let(:ip) { '1.1.1.333' }

        it 'adds expected error message', :aggregate_failures do
          expect(record).not_to be_valid
          expect(record.errors[:ip]).to include('Invalid IP address format')
        end
      end
    end
  end
end
