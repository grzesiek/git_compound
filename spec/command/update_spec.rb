require 'workers/shared_examples/component_update_dispatcher'
require 'workers/shared_examples/local_changes_guard'
require 'workers/shared_examples/task_runner'
require 'workers/shared_context/out_of_date_environment'

describe GitCompound do
  describe '#update' do
    include_context 'out of date environment'

    subject do
      -> { GitCompound.update("#{@base_component_dir}/Compoundfile") }
    end

    it_behaves_like 'component update dispatcher worker'

    pending 'removes dormant components' do
      fail 'TODO'
    end

    pending 'updates lockfile' do
      fail 'TODO'
    end
  end
end
