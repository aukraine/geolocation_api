RSpec.describe Errors::InternalServerError do
  subject { described_class.new }

  let(:error) { 'An error has occurred on the backend.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(500) }
end
