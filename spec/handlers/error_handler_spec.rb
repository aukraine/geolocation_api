RSpec.describe ErrorHandler do
  describe '#call' do
    subject { described_class.call(error.new) }

    context 'when raised error is kind of Errors::Base' do
      let(:error) { Errors::Base }

      it { is_expected.to be_a Errors::Base }
    end

    context 'when raised error is ActiveRecord::RecordNotFound' do
      let(:error) { ActiveRecord::RecordNotFound }

      it { is_expected.to be_a Errors::NotFound }
    end

    context 'when raised error is ActiveRecord::RecordNotUnique' do
      let(:error) { ActiveRecord::RecordNotUnique }

      it { is_expected.to be_a Errors::UnprocessableEntity }
    end

    context 'when raised error is ArgumentError' do
      let(:error) { ArgumentError }

      it { is_expected.to be_a Errors::BadRequest }
    end

    context 'when raised error is any kind of Errors::Base' do
      let(:error) { Errors::UnprocessableEntity }

      it { is_expected.to be_a Errors::UnprocessableEntity }
    end

    context 'when raised error is StandardError' do
      let(:error) { StandardError }

      it { is_expected.to be_a Errors::Base }
    end
  end
end
