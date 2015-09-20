require 'workers/shared_examples/local_changes_guard'

# GitCompound
#
module GitCompound
  describe Worker::LocalChangesGuard do
    let!(:component_1) { create_component_1 }

    let(:component) do
      component_1_src = component_1.origin
      Component.new(:component_1) do
        branch 'master'
        source component_1_src
        destination 'test_component_1_dir_built/'
      end
    end

    let(:lock) { Lock.new }
    let(:destination) { component.path }

    before { component.build! }

    subject do
      -> { described_class.new(lock).visit_component(component) }
    end

    context 'component repository exists' do
      it_behaves_like 'local changes guard worker'
    end

    context 'repository does not exist' do
      let(:component) do
        component_dir = component_1.origin
        Component.new(:tmp) do
          branch 'master'
          source component_dir
          destination 'non/existent'
        end
      end

      it 'should not raise error' do
        expect { subject.call }.to_not raise_error
      end
    end
  end
end
