require 'workers/shared_examples/task_runner'

# Git compound
#
module GitCompound
  describe Worker::TaskRunner do
    before { create_all_components! }
    let(:manifest) { manifest! }

    subject { -> { manifest.process(described_class.new) } }

    it_behaves_like 'task runner worker'
  end
end
