require 'lock/shared_context/lock_file'
require 'workers/shared_examples/component_builder'

# GitCompound
#
module GitCompound
  describe Lock do
    describe 'building from lock' do
      include_context 'existing lockfile'
      subject { -> { @lock.build } }
      let(:components) { @lock.components }

      it_behaves_like 'component builder worker'
    end
  end
end
