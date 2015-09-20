# rubocop:disable Metrics/ModuleLength
# GitCompound
#
module GitCompound
  describe Component do
    describe '#update!' do
      shared_examples 'component updater' do
        it 'updates component' do
          expect(File.read(destination + 'new_update_file'))
            .to eq "new_file_contents\n"
        end

        it 'updates HEAD' do
          expect(component_new.repository.head_sha).to eq new_sha
        end

        it 'checkouts on symbolic ref' do
          expect(git(destination) { git_current_ref }).to eq symbolic_ref
        end
      end

      let!(:component_2) { create_component_2 }
      let(:destination) { "#{@dir}/#{component_new.path}" }

      context 'new tag version' do
        let(:component_old) do
          component_dir = component_2.origin
          Component.new(:component_2) do
            version '0.1'
            source component_dir
            destination '/component_2_destination'
          end
        end

        let(:new_sha) do
          git(component_2.origin) do
            git_add_file('new_update_file') { 'new_file_contents' }
            git_commit('2.0 commit')
            git_tag('2.0', 'version 2.0')
          end
        end

        let(:component_new) do
          component_dir = component_2.origin
          Component.new(:component_2) do
            version '2.0'
            source component_dir
            destination '/component_2_destination'
          end
        end

        let(:symbolic_ref) { '2.0' }

        before do
          # Build component first
          #
          component_old.build!

          # Change source repository of component
          new_sha

          # Update component
          #
          component_new.update!
        end

        it_behaves_like 'component updater'
      end

      context 'new commits in branch' do
        let(:component_new) do
          component_dir = component_2.origin
          Component.new(:component_2) do
            branch 'master'
            source component_dir
            destination '/component_2_destination'
          end
        end

        let(:new_sha) do
          git(component_2.origin) do
            git_add_file('new_update_file') { 'new_file_contents' }
            git_commit('new master commit')
          end
        end

        let(:symbolic_ref) { 'master' }

        before do
          # Build component first
          #
          component_new.build!

          # Change source repository of component
          #
          new_sha

          # Update component
          component_new.update!
        end

        it_behaves_like 'component updater'
      end

      context 'new sha version' do
        context 'sha matches ref' do
          let(:component_old) do
            component_dir = component_2.origin
            initial_sha = component_2.metadata[:tag_v1_2_sha]
            Component.new(:component_2) do
              sha initial_sha
              source component_dir
              destination '/component_2_destination'
            end
          end

          let(:new_sha) do
            git(component_2.origin) do
              git_add_file('new_update_file') { 'new_file_contents' }
              git_commit('new master commit')
            end
          end

          let(:component_new) do
            component_dir = component_2.origin
            new_version_sha = new_sha
            Component.new(:component_2) do
              sha new_version_sha
              source component_dir
              destination '/component_2_destination'
            end
          end

          let(:symbolic_ref) { 'master' }

          before do
            # Build component first
            #
            component_old.build!

            # Change source repository of component
            #
            new_sha

            # Update component, version strategy points to newest sha, that
            # is in fact master HEAD
            #
            component_new.update!
          end

          it_behaves_like 'component updater'
        end

        context 'sha does not match ref' do
          let(:component_old) do
            component_dir = component_2.origin
            initial_sha = component_2.metadata[:tag_v1_2_sha]
            Component.new(:component_2) do
              sha initial_sha
              source component_dir
              destination '/component_2_destination'
            end
          end

          let(:new_sha) do
            git(component_2.origin) do
              git_add_file('new_update_file') { 'new_file_contents' }
              git_commit('wanted master commit')
            end
          end

          let(:unwanted_sha) do
            git(component_2.origin) do
              git_add_file('second_update_file') { 'second_file_contents' }
              git_commit('unwanted master commit')
            end
          end

          let(:component_new) do
            new_version_sha = new_sha
            component_dir = component_2.origin
            Component.new(:component_2) do
              sha new_version_sha
              source component_dir
              destination '/component_2_destination'
            end
          end

          before do
            # Build component first
            #
            component_old.build!

            # Change source repository of component
            #
            new_sha
            unwanted_sha

            # Update component
            component_new.update!
          end

          it 'updates component' do
            expect(File.read(destination + 'new_update_file'))
              .to eq "new_file_contents\n"
          end

          it 'updates HEAD' do
            expect(component_new.repository.head_sha).to eq new_sha
          end

          it 'does not exceed beyond expected boundary' do
            expect(File.exist?(destination + 'second_update_file')).to be false
          end
        end

        context 'HEAD on local-only branch' do
          let(:destination) { 'component_2_destination' }

          let(:component) do
            component_source_dir = component_2.origin
            component_destination_dir = destination
            Component.new(:component_2) do
              branch 'master'
              source component_source_dir
              destination component_destination_dir
            end
          end

          let(:unwanted_sha) do
            git(destination) do
              git_branch_new('test/test-branch')
              git_add_file('new_update_file') { 'new_file_contents' }
              git_commit('new commit on test/test-branch')
            end
          end

          before do
            # Build component first
            #
            component.build!

            # Change local repository
            #
            unwanted_sha
            git(destination) { git_branch_push('test/test-branch') }

            # Update component
            #
            component.update!
          end

          it 'does not merge branch previously checked out' do
            ref = git(component.path) { git_current_ref }
            sha = git(component.path) { git_head_sha }

            expect(ref).to eq 'master'
            expect(sha).to eq component_2.metadata[:tag_v1_2_sha]
            expect(sha).to_not eq unwanted_sha
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
