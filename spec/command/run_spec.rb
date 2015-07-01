describe GitCompound do
  describe '#run' do
    context 'commad is valid' do
      before { git_build_test_environment! }
      subject do
        -> { GitCompound.run('show', ["#{@base_component_dir}/Compoundfile"]) }
      end

      it 'executes given command' do
        expect { subject.call }.to output(/`component_1`/).to_stdout
        expect { subject.call }.to output(/`leaf_component_3`/).to_stdout
      end

      it 'does not raise error if command is valid' do
        expect { subject.call }.to_not raise_error
      end

      it 'does not print help if command is valid' do
        expect { subject.call }.to_not output(/Usage:/).to_stdout
      end
    end

    context 'command is invalid' do
      subject do
        -> { GitCompound.run('invalid', []) }
      end

      it 'does not raise error if command is invalid' do
        expect { subject.call }.to raise_error SystemExit
      end

      it 'print usage if command is invalid' do
        expect { subject.call }.to raise_error(SystemExit, /Usage:/)
      end
    end
  end
end
