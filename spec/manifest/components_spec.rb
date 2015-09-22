# GitCompound
#
module GitCompound
  describe Manifest do
    describe 'dependencies' do
      let!(:components) { create_all_components! }
      subject { manifest! }

      it 'should load all dependencies' do
        expect(subject.components.count).to eq 2
      end

      it 'should set valid names for required components' do
        expect(subject.components).to include(:component_1)
        expect(subject.components).to include(:component_2)
      end

      it 'should set valid sources for required components' do
        component_1_source = subject.components[:component_1].origin
        component_2_source = subject.components[:component_2].origin
        expect(component_1_source).to eq components[:component_1].origin
        expect(component_2_source).to eq components[:component_2].origin
      end

      it 'it should process required dependencies' do
        subject.process
        required_components =
          subject.components[:component_1].manifest.components
        expect(required_components.count).to eq 2
        expect(required_components).to include(:leaf_component_1)
        expect(required_components).to include(:leaf_component_2)
      end

      it 'should load required component from valid ref' do
        subject.process
        required_components =
          subject.components[:component_2].manifest.components
        expect(required_components.count).to eq 1
        expect(required_components).to include(:leaf_component_3)
      end

      it 'should raise error if there is no maching version' do
        component_dir = components[:component_1].origin
        component = Component.new(:test) do
          version '>6.0'
          source component_dir
          destination 'any'
        end
        expect { component.process }.to raise_error DependencyError
      end

      it 'should raise error if there is no maching ref' do
        component_dir = components[:component_1].origin
        component = Component.new(:test) do
          branch 'non-existent'
          source component_dir
          destination 'any'
        end
        expect { component.process }.to raise_error DependencyError
      end
    end
  end
end
