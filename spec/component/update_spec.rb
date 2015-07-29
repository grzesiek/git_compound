
# GitCompound
#
module GitCompound
  describe Component do
    describe '#update!' do
      shared_examples 'component updater' do
        it 'should update master branch' do
          expect(File.read(@destination + 'new_update_file'))
            .to eq "new_file_contents\n"
        end

        it 'updates HEAD' do
          expect(@component_new.repository.head_sha).to eq @sha
        end

        it 'checkouts on symbolic ref' do
          expect(git(@destination) { git_current_ref }).to eq @symbolic_ref
        end
      end

      context 'new tag version' do
        before do
          git_create_component_2

          # Build component first
          #
          component_dir = @component_2_dir
          @component_old = Component.new(:component_2) do
            version '0.1'
            source component_dir
            destination '/component_2_destination'
          end
          @component_old.build!

          # Change source repository of component
          #
          git(@component_2_dir) do
            git_add_file('new_update_file') { 'new_file_contents' }
            git_commit('2.0 commit')
            @sha = git_tag('2.0', 'version 2.0')
          end

          # Update component
          #
          @component_new = Component.new(:component_2) do
            version '2.0'
            source component_dir
            destination '/component_2_destination'
          end
          @component_new.update!

          @symbolic_ref = '2.0'
          @destination = "#{@dir}/#{@component_new.path}"
        end

        it_behaves_like 'component updater'
      end

      context 'new commits in branch' do
        before do
          git_create_component_2

          # Build component first
          #
          component_dir = @component_2_dir
          @component_new = Component.new(:component_2) do
            branch 'master'
            source component_dir
            destination '/component_2_destination'
          end
          @component_new.build!

          # Change source repository of component
          #
          git(@component_2_dir) do
            git_add_file('new_update_file') { 'new_file_contents' }
            @sha = git_commit('new master commit')
          end
          @component_new.update!

          @symbolic_ref = 'master'
          @destination  = "#{@dir}/#{@component_new.path}"
        end

        it_behaves_like 'component updater'
      end

      context 'new sha version' do
        before do
          git_create_component_2

          # Build component first
          #
          component_dir = @component_2_dir
          initial_sha = @component_2_commit_tag_v1_2_sha
          @component_old = Component.new(:component_2) do
            sha initial_sha
            source component_dir
            destination '/component_2_destination'
          end
          @component_old.build!

          # Change source repository of component
          #
          git(@component_2_dir) do
            git_add_file('new_update_file') { 'new_file_contents' }
            @sha = git_commit('new master commit')
          end

          # Update component, version strategy points to newest sha, that
          # is in fact master HEAD
          #
          new_sha = @sha
          @component_new = Component.new(:component_2) do
            sha new_sha
            source component_dir
            destination '/component_2_destination'
          end
          @component_new.update!

          @symbolic_ref = 'master'
          @destination  = "#{@dir}/#{@component_new.path}"
        end

        it_behaves_like 'component updater'
      end
    end
  end
end
