RSpec.describe Errors::Unauthorized do
  subject { described_class.new }

  let(:error) { 'Unauthorized request.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(401) }
end
