require 'workers/shared_examples/task_runner'

# Git compound
#
module GitCompound
  describe Worker::TaskRunner do
    before do
      git_build_test_environment!
    end

    subject do
      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      manifest = Manifest.new(manifest_contents)
      -> { manifest.process(described_class.new) }
    end

    it_behaves_like 'task runner worker'
  end
end
