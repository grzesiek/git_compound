# GitCompound
#
module GitCompound
  describe Command::Arguments::Type::Argument::String do
    subject { described_class.new(:str_argument, args) }

    context 'parameter supplied' do
      let(:args) { [:parameter, 'argument_1', '1', :other] }

      it 'is valid' do
        expect(subject.valid?).to eq true
      end

      it 'parses args' do
        expect(subject.parse).to eq(str_argument: 'argument_1')
      end

      it 'returns used arguments' do
        expect(subject.used).to eq ['argument_1']
      end
    end

    context 'parameter not supplied' do
      let(:args) { [:parameter_irrelevant] }

      it 'is invalid' do
        expect(subject.valid?).to eq false
      end

      it 'returns empty hash' do
        expect(subject.parse).to eq({})
      end

      it 'returns empty array as used arguments' do
        expect(subject.used).to eq []
      end
    end
  end
end
