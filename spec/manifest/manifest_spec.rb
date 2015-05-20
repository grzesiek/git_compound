# GitCompound
module GitCompound
  describe Manifest do
    before do
      @valid_contents = <<-END
        name :test_project
        component :test_component do
          version     '~>1.1'
          source      'src'
          destination 'dst'
        end
        task :first_task do
        end
      END
    end

    context 'when loaded from file' do
      before do
        @compound_file = 'Compoundfile'
        File.open(@compound_file, 'w') do |f|
          f.puts @valid_contents
        end
        @manifest = described_class.load!(@compound_file)
      end

      it 'should read it and return instance of Manifest' do
        expect(@manifest).to be_an_instance_of Manifest
      end

      it 'should raise exception if file is not found' do
        expect { described_class.load!('nonexistent') }.to raise_error \
          CompoundLoadError
      end
    end

    context 'when not loaded from file' do
      context 'when content is supplied as second argument' do
        it 'should evaluate contents if it is valid' do
          manifest = described_class.new.evaluate(nil, @valid_contents)
          expect(manifest).to be_instance_of Manifest
        end

        it 'should raise exception if syntax is invalid' do
          expect do
            described_class.new.evaluate(nil, 'non_existent_method')
          end.to raise_error CompoundSyntaxError
        end
      end
    end
  end
end
