RSpec.describe Errors::UnprocessableEntity do
  subject { described_class.new }

  let(:error) { 'The record with specified attributes could not be processed.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(422) }
end
