
# GitCompound
#
module GitCompound
  describe Component do
    describe '#update!' do
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

          @destination = "#{@dir}/#{@component_new.path}"
        end

        it 'should checkout new tag' do
          expect(File.read(@destination + 'new_update_file'))
            .to eq "new_file_contents\n"
        end

        it 'updates HEAD' do
          expect(@component_new.repository.head_sha).to eq @sha
        end
      end

      context 'new commits in branch' do
        before do
          git_create_component_2

          # Build component first
          #
          component_dir = @component_2_dir
          @component = Component.new(:component_2) do
            branch 'master'
            source component_dir
            destination '/component_2_destination'
          end
          @component.build!

          # Change source repository of component
          #
          git(@component_2_dir) do
            git_add_file('new_update_file') { 'new_file_contents' }
            @sha = git_commit('new master commit')
          end
          @component.update!

          @destination = "#{@dir}/#{@component.path}"
        end

        it 'should update master branch' do
          expect(File.read(@destination + 'new_update_file'))
            .to eq "new_file_contents\n"
        end

        it 'updates HEAD' do
          expect(@component.repository.head_sha).to eq @sha
        end
      end
    end
  end
end
