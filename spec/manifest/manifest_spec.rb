# GitCompound
module GitCompound
  describe Manifest do
    context 'load compound manifest from file' do
      before do
        @compound_file = 'Compoundfile'
        File.open(@compound_file, 'w') do |f|
          f.puts 'name :test_project'
        end
      end

      it 'should raise exception if file is not found' do
        expect { described_class.load!('nonexistent') }.to raise_error \
          CompoundLoadError
      end

      it 'should raise exception if syntax is invalid' do
        expect do
          described_class.new.evaluate(nil, 'non_existent_method')
        end.to raise_error CompoundSyntaxError
      end

      it 'should be loaded from file' do
        manifest = described_class.load!(@compound_file)
        expect(manifest).to be_an_instance_of Manifest
      end
    end
  end
end
