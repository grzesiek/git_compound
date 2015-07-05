# GitCompound
#
module GitCompound
  describe Worker::LocalChangesGuard do
    before do
      git_create_component_2

      component_2_src = @component_2_dir
      @component_2_dst = 'test_component_2_dir_built/'
      component_2_dst  = @component_2_dst

      @component = Component.new(:component_2) do
        branch 'master'
        source component_2_src
        destination component_2_dst
      end

      @component.build
    end

    subject do
      -> { described_class.new.visit_component(@component) }
    end

    context 'repository is clean' do
      it 'should not raise error if repository is clean' do
        expect { subject.call }.to_not raise_error
      end
    end

    context 'repository has uncommited changes' do
      before do
        git(@component_2_dst) do
          File.open('Compoundfile', 'w') { |f| f.puts 'tracked file editted' }
        end
      end

      it 'should raise error if local changes are detected' do
        expect { subject.call }.to raise_error(LocalChangesError,
                                               /contains uncommited changes/)
      end
    end

    context 'repository has untracked files' do
      before do
        git(@component_2_dst) do
          File.open('untracked_file', 'w') { |f| f.puts 'added untracked file' }
        end
      end

      it 'should raise error if untracked file is detected' do
        expect { subject.call }.to raise_error(LocalChangesError,
                                               /contains untracked files/)
      end
    end

    context 'repository has unpushed commits' do
      before do
        git(@component_2_dst) do
          git_add_file('component_2_new_file') { 'new file ' }
          git_commit('commit changes')
        end
      end

      it 'should raise error if unpushed commits are detected' do
        expect { subject.call }.to raise_error(LocalChangesError,
                                               /contains unpushed commits/)
      end
    end
  end
end
