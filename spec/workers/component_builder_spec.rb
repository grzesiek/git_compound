require 'workers/shared_examples/component_builder'

# GitCompound
#
module GitCompound
  describe Worker::ComponentBuilder do
    before { git_build_test_environment! }

    subject do
      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      manifest = Manifest.new(manifest_contents)
      -> { manifest.process(described_class.new) }
    end

    it_behaves_like 'component builder worker'
  end
end
