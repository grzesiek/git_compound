require 'workers/shared_examples/pretty_print'

# Git compound
#
module GitCompound
  describe Worker::PrettyPrint do
    before { create_all_components! }
    let(:manifest) { manifest! }

    subject { -> { manifest.process(described_class.new) } }

    it_behaves_like 'pretty print worker'
  end
end
