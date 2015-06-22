# GitCompound
#
module GitCompound
  describe Worker::ComponentBuilder do
    before do
      git_build_test_environment!

      contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(contents)
      @manifest.process(described_class.new)
    end

    pending 'should use all required components' do
    end

    pending 'should checkout valid refs' do
    end

    pending 'should clone components to valid destinations' do
    end
  end
end
