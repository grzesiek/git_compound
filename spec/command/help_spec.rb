describe GitCompound do
  describe '#help' do
    subject do
      -> { GitCompound.help }
    end

    it 'outputs help for build method' do
      expect { subject.call }.to output(/gitcompound build/).to_stdout
    end

    it 'outputs help for update method' do
      expect { subject.call }.to output(/gitcompound update/).to_stdout
    end

    it 'outputs help for check method' do
      expect { subject.call }.to output(/gitcompound check/).to_stdout
    end

    it 'outputs help for show method' do
      expect { subject.call }.to output(/gitcompound show/).to_stdout
    end

    it 'outputs help for help method' do
      expect { subject.call }.to output(/gitcompound help/).to_stdout
    end
  end
end
