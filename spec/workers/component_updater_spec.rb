require 'workers/shared_examples/component_updater'
require 'workers/shared_context/out_of_date_environment'

# GitCompound
#
module GitCompound
  describe Worker::ComponentUpdater do
    include_context 'out of date environment'

    subject do
      -> { @manifest.process(described_class.new(@lock)) }
    end

    it_behaves_like 'component updater worker'
  end
end
