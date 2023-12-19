RSpec.describe Errors::BadGateway do
  subject { described_class.new }

  let(:error) { 'The server, while acting as a gateway or proxy, received an invalid response.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(502) }
end
