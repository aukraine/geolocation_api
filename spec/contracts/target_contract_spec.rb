RSpec.describe TargetContract, type: :contract do
  subject(:contract) { described_class.new }

  let(:payload) { { target: target } }

  describe 'with valid input' do
    context 'when value is IPv4 address' do
      let(:target) { Faker::Internet.ip_v4_address }

      it 'passes validation' do
        expect(contract.call(payload)).to be_success
      end
    end

    context 'when value is IPv6 address' do
      let(:target) { Faker::Internet.ip_v6_address }

      it 'passes validation' do
        expect(contract.call(payload)).to be_success
      end
    end

    context 'when value is URL address' do
      let(:target) { Faker::Internet.url }

      it 'passes validation' do
        expect(contract.call(payload)).to be_success
      end
    end

    context 'when value is domain address' do
      let(:target) { Faker::Internet.domain_name }

      it 'passes validation' do
        expect(contract.call(payload)).to be_success
      end
    end
  end

  describe 'with invalid input' do
    context 'when there are missed keys' do
      let(:payload) { {} }

      it 'fails validation' do
        expect(contract.call(payload)).to be_failure
      end
    end

    context 'when value is not string' do
      let(:target) { 1 }

      it 'fails validation' do
        expect(contract.call(payload)).to be_failure
      end
    end

    context 'when value is empty string' do
      let(:target) { '' }

      it 'fails validation' do
        expect(contract.call(payload)).to be_failure
      end
    end

    context 'when value is just any string' do
      let(:target) { 'foo bar' }

      it 'fails validation', :aggregate_failures do
        expect(contract.call(payload)).to be_failure
        expect(contract.call(payload).errors.to_h[:target]).to include('Invalid IP or URL address format')
      end
    end

    context 'when value is invalid IP address' do
      let(:target) { '192.168.0.256' }

      it 'fails validation', :aggregate_failures do
        expect(contract.call(payload)).to be_failure
        expect(contract.call(payload).errors.to_h[:target]).to include('Invalid IP or URL address format')
      end
    end

    context 'when value is invalid URL address' do
      let(:target) { 'www.google.c' }

      it 'fails validation', :aggregate_failures do
        expect(contract.call(payload)).to be_failure
        expect(contract.call(payload).errors.to_h[:target]).to include('Invalid IP or URL address format')
      end
    end
  end
end
