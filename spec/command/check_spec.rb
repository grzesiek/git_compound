require 'workers/shared_examples/pretty_print'

describe GitCompound do
  describe '#show' do
    before { create_all_components! }

    context 'dependencies are valid' do
      subject { -> { GitCompound.check(manifest_path!) } }

      it 'print information about valid dependencies' do
        expect { subject.call }.to output(/OK/).to_stdout
      end
    end
  end
end
