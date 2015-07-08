require 'workers/shared_examples/local_changes_guard'

# GitCompound
#
module GitCompound
  describe Worker::LocalChangesGuard do
    before do
      git_create_component_1

      component_1_src = @component_1_dir
      @component_1_dst = 'test_component_1_dir_built/'
      component_1_dst  = @component_1_dst

      @component = Component.new(:component_1) do
        branch 'master'
        source component_1_src
        destination component_1_dst
      end

      @component.build

      @lock = Lock.new
    end

    subject do
      -> { described_class.new(@lock).visit_component(@component) }
    end

    it_behaves_like 'local changes guard worker'
  end
end
