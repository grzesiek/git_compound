# Git compound
#
module GitCompound
  describe Worker::TaskRunner do
    before do
      git_build_test_environment!

      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(manifest_contents)
    end

    pending 'should visit tasks in reverse order' do
      @manifest.process(described_class.new)
      fail 'todo'
    end
  end
end
