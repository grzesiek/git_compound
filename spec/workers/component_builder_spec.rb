require 'workers/shared_examples/component_builder'

# GitCompound
#
module GitCompound
  describe Worker::ComponentBuilder do
    let!(:components) { create_all_components!.values }
    let(:manifest) { manifest! }

    subject { -> { manifest.process(described_class.new) } }

    it_behaves_like 'component builder worker'
  end
end
