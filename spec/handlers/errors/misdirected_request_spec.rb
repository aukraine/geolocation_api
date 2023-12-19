RSpec.describe Errors::MisdirectedRequest do
  subject { described_class.new }

  let(:error) { 'The request was directed to a server that is not able to produce a response.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(421) }
end
