# GitCompound
#
module GitCompound
  describe Worker::ComponentBuilder do
    before do
      git_build_test_environment!

      contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(contents)
    end
  end
end
