RSpec.describe Errors::NotFound do
  subject { described_class.new }

  let(:error) { 'The record with specified attributes is not found.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(404) }
end
