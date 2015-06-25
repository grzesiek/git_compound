require 'workers/shared_examples/component_builder'
require 'workers/shared_examples/task_runner'
require 'workers/shared_examples/pretty_print'

describe GitCompound do
  describe '#build' do
    before { git_build_test_environment! }

    subject do
      -> { GitCompound.build("#{@base_component_dir}/Compoundfile") }
    end

    it_behaves_like 'component builder worker'
    it_behaves_like 'task runner worker'
  end

  describe '#show' do
    before { git_build_test_environment! }

    subject do
      -> { GitCompound.show("#{@base_component_dir}/Compoundfile") }
    end

    it_behaves_like 'pretty print worker'
  end
end
