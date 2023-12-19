RSpec.describe Ipstack::GetData, type: :lib do
  subject { described_class.new }

  describe '#call' do
    let(:url) { "http://api.ipstack.com/#{target}" }
    let(:target) { 'target' }
    let(:response) { instance_double('response', success?: success) }
    let(:success) { true }

    before { allow(Faraday).to receive(:get).and_return(response) }

    it 'returns response object' do
      expect(subject.call(target)).to eq(response)
    end

    context 'when response is success' do
      let(:success) { true }

      it 'invokes 3rd party service via external call' do
        expect(Faraday).to receive(:get).with(url, access_key: String, output: :json)
        subject.call(target)
      end
    end

    context 'when response is failure' do
      let(:response) { instance_double('response', success?: success, status: 400, body: 'body') }
      let(:success) { false }

      it 'logs error message' do
        expect(Rails.logger).to receive(:error).with("[ERROR] [Ipstack::GetData] url=#{url} status=400 body=body")
        subject.call(target)
      end
    end
  end
end
