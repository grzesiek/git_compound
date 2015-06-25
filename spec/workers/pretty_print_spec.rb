require 'workers/shared_examples/pretty_print'

# Git compound
#
module GitCompound
  describe Worker::PrettyPrint do
    before { git_build_test_environment! }

    subject do
      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      manifest = Manifest.new(manifest_contents)
      -> { manifest.process(described_class.new) }
    end

    it_behaves_like 'pretty print worker'
  end
end
