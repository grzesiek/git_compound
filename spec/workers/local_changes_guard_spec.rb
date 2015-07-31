require 'workers/shared_examples/local_changes_guard'

# GitCompound
#
module GitCompound
  describe Worker::LocalChangesGuard do
    before do
      git_create_component_1

      @component_1_dst = 'test_component_1_dir_built/'
      component_1_src = @component_1_dir
      component_1_dst = @component_1_dst

      @component = Component.new(:component_1) do
        branch 'master'
        source component_1_src
        destination component_1_dst
      end

      @component.build!
      @lock = Lock.new
    end

    subject do
      -> { described_class.new(@lock).visit_component(component) }
    end

    context 'component repository exists' do
      let(:component) { @component }

      it_behaves_like 'local changes guard worker'
    end

    context 'repository does not exist' do
      let(:component) do
        component_dir = @component_1_dir
        Component.new(:tmp) do
          branch 'master'
          source component_dir
          destination 'non existent'
        end
      end

      it 'should not raise error' do
        expect { subject.call }.to_not raise_error
      end
    end
  end
end
