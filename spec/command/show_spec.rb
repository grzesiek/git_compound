require 'workers/shared_examples/pretty_print'

describe GitCompound do
  describe '#show' do
    before { create_all_components! }
    subject { -> { GitCompound.show(manifest_path!) } }

    it_behaves_like 'pretty print worker'
  end
end
