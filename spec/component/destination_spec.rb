# GitCompound
#
module GitCompound
  describe Component::Destination do
    let!(:base_component) { create_base_component }

    let(:component) do
      component_dir = base_component.origin
      Component.new(:base_component) do
        branch 'master'
        source component_dir
        destination '/base_component'
      end
    end

    let(:component_1) { component.manifest.components[:component_1] }
    let(:component_2) { component.manifest.components[:component_2] }
    let(:leaf_component_1) { component_1.manifest.components[:leaf_component_1] }
    let(:leaf_component_2) { component_1.manifest.components[:leaf_component_2] }

    it 'returns valid expanded destinations paths' do
      expect(component_1.path).to eq 'component_1_destination/'
      expect(component_2.path).to eq 'component_2_destination/'
      expect(leaf_component_1.path).to eq 'leaf_component_1_destination/'
      expect(leaf_component_2.path)
        .to eq 'base_component/component_1_destination/leaf_component_2_destination/'
    end

    it 'raises error if destination is not directory' do
      expect { Component::Destination.new('/', component) }
        .to raise_error(CompoundSyntaxError, /should contain at least one directory/)
    end
  end
end
