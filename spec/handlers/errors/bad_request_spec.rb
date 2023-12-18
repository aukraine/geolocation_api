RSpec.describe Errors::BadRequest do
  subject { described_class.new }

  let(:error) { 'The request cannot be completed.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(400) }
end
