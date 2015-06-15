# GitCompound
#
module GitCompound
  describe Manifest do
    describe 'dependencies' do
      before do
        git_build_test_environment!

        manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
        @manifest = Manifest.new(manifest_contents)
      end

      it 'should load all dependencies' do
        expect(@manifest.components.count).to eq 2
      end

      it 'should set valid names for required components' do
        expect(@manifest.components).to include(:component_1)
        expect(@manifest.components).to include(:component_2)
      end

      it 'should set valid sources for required components' do
        component_1_source = @manifest.components[:component_1].source.location
        component_2_source = @manifest.components[:component_2].source.location
        expect(component_1_source).to eq @component_1_dir
        expect(component_2_source).to eq @component_2_dir
      end

      it 'it should process required components dependencies' do
        @manifest.process
        required_components =
          @manifest.components[:component_1].manifest.components
        expect(required_components.count).to eq 2
        expect(required_components).to include(:leaf_component_1)
        expect(required_components).to include(:leaf_component_2)
      end

      it 'should load required component from valid ref' do
        @manifest.process
        required_components =
          @manifest.components[:component_2].manifest.components
        expect(required_components.count).to eq 1
        expect(required_components).to include(:leaf_component_3)
      end

      it 'should raise error if there is no maching version' do
        component_dir = @component_1_dir
        component = Component.new(:test) do
          version '>6.0'
          source component_dir
          destination 'any'
        end
        expect { component.process }.to raise_error DependencyError
      end

      it 'should raise error if there is no maching ref' do
        component_dir = @component_1_dir
        component = Component.new(:test) do
          sha 'a2b0fec89736deba6cc647bcc2b238812c3725ad'
          source component_dir
          destination 'any'
        end
        expect { component.process }.to raise_error DependencyError
      end
    end
  end
end
