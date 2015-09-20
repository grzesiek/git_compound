require 'workers/shared_context/out_of_date_environment'
require 'workers/shared_examples/component_dispatcher'

# GitCompound
#
module GitCompound
  describe Worker::ComponentDispatcher do
    include_context 'out of date environment'

    subject { -> { manifest.process(described_class.new(Lock.new)) } }

    it_behaves_like 'component dispatcher worker'
  end
end
