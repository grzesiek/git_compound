# GitCompound
#
module GitCompound
  describe Command::Arguments::Type::Parameter::String do
    subject { described_class.new(:str_parameter, args) }

    context 'parameter supplied' do
      let(:args) { ['argument1', :str_parameter, 'relevant_value', :other] }

      it 'is valid' do
        expect(subject.valid?).to eq true
      end

      it 'parses args' do
        expect(subject.parse).to eq(str_parameter: 'relevant_value')
      end

      it 'returns used arguments' do
        expect(subject.used).to eq [:str_parameter, 'relevant_value']
      end
    end

    context 'parameter not supplied' do
      let(:args) { ['argument1', :parameter_invalid, 'relevant_value', :other] }

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
