# GitCompound
#
module GitCompound
  describe Worker::ComponentUpdater do
    before do
      git_create_leaf_component_1

      component_dir = @leaf_component_1_dir
      component = Component.new(:leaf_component_1) do
        version '=1.0'
        source component_dir
        destination '/tmp_leaf_component_1_test_dir'
      end

      component.build!

      git(@leaf_component_1_dir) do
        git_add_file('new_component_file') { 'new_component_test_file' }
        git_commit('2.0 commit')
        git_tag('2.0', 'version 2.0')
      end

      @updated_component = Component.new(:leaf_component_1) do
        version '2.0'
        source component_dir
        destination '/tmp_leaf_component_1_test_dir'
      end

      @lock = Lock.new
      @lock.lock_component(component)
    end

    subject do
      -> { described_class.new(@lock).visit_component(@updated_component) }
    end

    it 'prints information about components being updated' do
      expect { subject.call }
        .to output(/^Updating:\s+`leaf_component_1` component, version: 2.0$/)
        .to_stdout
    end

    it 'checkouts new ref for updated components' do
      subject.call
      current_ref = git("#{@dir}/tmp_leaf_component_1_test_dir") { git_current_ref }
      expect(current_ref).to eq '2.0'
    end
  end
end
