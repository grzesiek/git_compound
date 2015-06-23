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
      fail
    end

    pending 'should checkout valid refs' do
      fail
    end

    pending 'should clone components to valid destinations' do
      fail
    end
  end
end
