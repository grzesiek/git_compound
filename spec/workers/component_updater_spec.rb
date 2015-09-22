# GitCompound
#
module GitCompound
  describe Worker::ComponentUpdater do
    let!(:leaf_component_1) { create_leaf_component_1 }

    let(:old_component) do
      component_dir = leaf_component_1.origin
      Component.new(:component_old) do
        version '=1.0'
        source component_dir
        destination '/tmp_leaf_component_1_test_dir'
      end
    end

    let(:updated_component) do
      component_dir = leaf_component_1.origin
      Component.new(:component_new) do
        version '2.0'
        source component_dir
        destination '/tmp_leaf_component_1_test_dir'
      end
    end

    let(:lock) { Lock.new }

    before do
      old_component.build!
      lock.lock_component(old_component)

      git(leaf_component_1.origin) do
        git_add_file('new_component_file') { 'new_component_test_file' }
        git_commit('2.0 commit')
        git_tag('2.0', 'version 2.0')
      end
    end

    subject do
      -> { described_class.new(lock).visit_component(updated_component) }
    end

    it 'prints information about components being updated' do
      expect { subject.call }
        .to output(/^Updating:\s+`component_new` component, version: 2.0$/)
        .to_stdout
    end

    it 'checkouts new ref for updated components' do
      subject.call
      current_ref = git("#{@dir}/tmp_leaf_component_1_test_dir") { git_current_ref }
      expect(current_ref).to eq '2.0'
    end
  end
end
