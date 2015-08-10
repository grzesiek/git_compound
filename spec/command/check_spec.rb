require 'workers/shared_examples/pretty_print'

describe GitCompound do
  describe '#show' do
    before { git_build_test_environment! }

    context 'dependencies are valid' do
      subject do
        -> { GitCompound.check("#{@base_component_dir}/Compoundfile") }
      end

      it 'print information about valid dependencies' do
        expect { subject.call }.to output(/OK/).to_stdout
      end
    end
  end
end
