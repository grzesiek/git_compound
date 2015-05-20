# GitCompound
module GitCompound
  describe Manifest do
    context 'when loaded compound manifest from file' do
      before do
        @compound_file = 'Compoundfile'
        File.open(@compound_file, 'w') do |f|
          f.puts 'name :test_project'
          f.puts 'component :test_component do'
          f.puts 'end'
        end
        @manifest = described_class.load!(@compound_file)
      end

      it 'should be instance of Manifest' do
        expect(@manifest).to be_an_instance_of Manifest
      end
    end

    context 'when not loaded from file' do
      it 'should raise exception if file is not found' do
        expect { described_class.load!('nonexistent') }.to raise_error \
          CompoundLoadError
      end

      context 'when manifest is supplied as second argument' do
        it 'should evaluate contents if it is valid' do
          manifest = described_class.new.evaluate('', 'name :test_project')
          expect(manifest).to be_instance_of Manifest
        end

        it 'should raise exception if syntax is invalid' do
          expect do
            described_class.new.evaluate('', 'non_existent_method')
          end.to raise_error CompoundSyntaxError
        end
      end
    end
  end
end
