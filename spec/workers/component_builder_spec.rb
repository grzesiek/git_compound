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

      @components = [ @component_1, @component_2, @leaf_component_1,
                      @leaf_component_2, @leaf_component_3 ]

      @manifest.process(described_class.new)
    end

    it 'should build all required components' do
      expect(@components.all? { |c| c.destination_exists? == true })
        .to be true
    end

    it 'should checkout valid refs' do
      result = @components.all? do |c|
        git(c.destination_path) { git_current_ref_matches?(c.source.ref) }
      end
      expect(result).to be true
    end
  end
end
