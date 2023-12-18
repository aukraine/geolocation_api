RSpec.describe Errors::Base do
  subject { described_class.new }

  let(:error) { 'An error has occurred on the backend.' }

  it { expect(subject.simple_error).to eq(error) }
  it { expect(subject.status_code).to eq(500) }

  describe '#error_detail' do
    it { expect(subject.simple_error).to eq(error) }

    context 'when error is provided' do
      subject { described_class.new(errors: error) }

      let(:error) { 'Some error message' }

      it 'expect to show error' do
        expect(subject.error_detail(error)).to eq(error)
      end
    end
  end
end
