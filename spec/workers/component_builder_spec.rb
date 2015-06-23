# GitCompound
#
module GitCompound
  describe Worker::ComponentBuilder do
    before do
      git_build_test_environment!

      contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(contents)

      @component_1 = @manifest.components[:component_1]
      @component_2 = @manifest.components[:component_2]
      @leaf_component_1 = @component_1.manifest.components[:leaf_component_1]
      @leaf_component_2 = @component_1.manifest.components[:leaf_component_2]
      @leaf_component_3 = @component_2.manifest.components[:leaf_component_3]

      @manifest.process(described_class.new)
    end

    it 'should build all required components' do
      expect(@component_1.destination_exists?).to be true
      expect(@component_2.destination_exists?).to be true
      expect(@leaf_component_1.destination_exists?).to be true
      expect(@leaf_component_2.destination_exists?).to be true
      expect(@leaf_component_3.destination_exists?).to be true
    end

    pending 'should checkout valid refs' do
      fail
    end

    pending 'should clone components to valid destinations' do
      fail
    end
  end
end
