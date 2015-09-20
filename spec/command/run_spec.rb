describe GitCompound do
  describe '#run' do
    before { create_all_components! }

    subject do
      proc do
        GitCompound.run(GitCompound::Command::Procedure::Show,
                        manifest: manifest_path!)
      end
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
end
