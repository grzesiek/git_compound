# GitCompound
#
module GitCompound
  describe Worker::ComponentsCollector do
    before do
      git_build_test_environment!
      @manifest = git_base_component_manifest
    end

    it 'should collect all components' do
      components = {}
      @manifest.process(described_class.new(components))
      expect(components.count).to eq 5
      components_expected = [:component_1, :leaf_component_1, :leaf_component_2,
                             :component_2, :leaf_component_3]
      expect(components.keys).to eq components_expected
    end
  end
end
