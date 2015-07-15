describe GitCompound do
  describe '#help' do
    subject do
      -> { GitCompound.help }
    end

    it 'outputs help for build method' do
      expect { subject.call }.to output(/^\s*build/).to_stdout
    end

    it 'outputs help for update method' do
      expect { subject.call }.to output(/^\s*update/).to_stdout
    end

    it 'outputs help for check method' do
      expect { subject.call }.to output(/^\s*check/).to_stdout
    end

    it 'outputs help for show method' do
      expect { subject.call }.to output(/^\s*show/).to_stdout
    end

    it 'outputs help for help method' do
      expect { subject.call }.to output(/^\s*help/).to_stdout
    end
  end
end
