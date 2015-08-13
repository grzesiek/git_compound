# GitCompound
#
module GitCompound
  describe Command::Options do
    context 'most common command line arguments' do
      context 'manifest only variant' do
        subject { described_class.new(%w(build Compoundfile)) }

        it 'parses procedure options' do
          expect(subject.options)
            .to eq(args: ['Compoundfile'])
        end
      end

      context 'manifest and parameter variant' do
        subject { described_class.new(%w(build --allow-nested-subtasks Compoundfile)) }

        it 'parses procedure options' do
          expect(subject.options)
            .to eq(allow_nested_subtasks: true, args: ['Compoundfile'])
        end
      end
    end

    context 'argv is valid' do
      subject do
        argv = ['--verbose', 'build', 'Compoundfile',
                '--allow-nested-subtasks', '--test-param', 'test-value',
                '--test-second', 'value_second', '--disable-colors']

        described_class.new(argv)
      end

      it 'parses global options' do
        expect(subject.global).to eq [:verbose, :disable_colors]
      end

      it 'parses procedure options' do
        expect(subject.options)
          .to eq(allow_nested_subtasks: true, test_param: 'test-value',
                 test_second: 'value_second', args: ['Compoundfile'])
      end

      it 'parses command' do
        expect(subject.command).to eq 'build'
      end

      it 'parses procedure' do
        expect(subject.procedure).to eq Command::Procedure::Build
      end

      it 'sets global options' do
        expect(Logger.verbose).to be true
        expect(Logger.colors).to be false
      end
    end

    context 'argv is invalid' do
      context 'invalid command' do
        subject do
          described_class.new(['invalid_command'])
        end

        it 'returns help procedure' do
          expect(subject.procedure).to eq Command::Procedure::Help
        end
      end
    end
  end
end
