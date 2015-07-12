require 'workers/shared_context/out_of_date_environment'
require 'workers/shared_examples/component_update_dispatcher'

# GitCompound
#
module GitCompound
  describe Worker::ComponentUpdateDispatcher do
    include_context 'out of date environment'

    subject do
      -> { @manifest.process(described_class.new(@lock, Lock.new)) }
    end

    it_behaves_like 'component update dispatcher worker'
  end
end
