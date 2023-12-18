RSpec.describe Errors::Forbidden do
  subject { described_class.new }

  let(:error) { 'The current user does not have access to perform the requested action.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(403) }
end
