require 'workers/shared_examples/pretty_print'

# Git compound
#
module GitCompound
  describe Worker::PrettyPrint do
    before { git_build_test_environment! }

    subject do
      manifest = git_base_component_manifest
      -> { manifest.process(described_class.new) }
    end

    it_behaves_like 'pretty print worker'
  end
end
