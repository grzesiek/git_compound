require 'workers/shared_examples/pretty_print'

describe GitCompound do
  describe '#show' do
    before { git_build_test_environment! }

    subject do
      -> { GitCompound.show("#{@base_component_dir}/Compoundfile") }
    end

    it_behaves_like 'pretty print worker'
  end
end
