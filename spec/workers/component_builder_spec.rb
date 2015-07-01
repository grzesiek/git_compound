require 'workers/shared_examples/component_builder'

# GitCompound
#
module GitCompound
  describe Worker::ComponentBuilder do
    before { git_build_test_environment! }

    subject do
      manifest = git_base_component_manifest
      -> { manifest.process(described_class.new) }
    end

    it_behaves_like 'component builder worker'
  end
end
