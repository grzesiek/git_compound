# GitCompound
#
module GitCompound
  describe Component::Destination do
    before do
      git_build_test_environment!

      component_dir = @base_component_dir
      @component = Component.new(:base_component) do
        branch 'master'
        source component_dir
        destination '/base_component'
      end

      @component_1 = @component.manifest.components[:component_1]
      @component_2 = @component.manifest.components[:component_2]
      @leaf_component_1 = @component_1.manifest.components[:leaf_component_1]
      @leaf_component_2 = @component_1.manifest.components[:leaf_component_2]
    end

    it 'returns valid expanded destinations paths' do
      expect(@component_1.destination_path).to eq 'component_1/'
      expect(@component_2.destination_path).to eq 'component_2/'
      expect(@leaf_component_1.destination_path)
        .to eq 'leaf_component_1_destination/'
      expect(@leaf_component_2.destination_path)
        .to eq 'base_component/component_1/leaf_component_2_destination/'
    end

    it 'raises error if destination is not directory' do
      expect { Component::Destination.new('/', @component) }
        .to raise_error(CompoundSyntaxError, /should contain at least one directory/)
    end
  end
end
