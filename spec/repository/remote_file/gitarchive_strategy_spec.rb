# GitCompound
#
module GitCompound
  describe Repository::RepositoryRemote do
    describe Repository::RemoteFile::GitArchiveStrategy do
      let!(:component) { create_leaf_component_1 }

      let!(:daemon) do
        git(component.origin) do
          git_add_file('Compoundfile') { 'name :test123' }
          git_commit('compoundfile commit')
          git_tag('test_tag', 'test_tag')
          git_edit_file('Compoundfile') { 'name :test321' }
          git_commit('compoundfile changed')
          git_tag('second_test_tag', 'second test_tag')

          FileUtils.touch("#{component.origin}/.git/git-daemon-export-ok")
          git_expose("#{component.origin}", 9999)
        end
      end

      let(:remote) { "git://localhost:9999#{component.origin}" }
      let(:repository) { Repository::RepositoryRemote.new(remote) }

      it 'should contain valid test_tag ref' do
        expect(repository.tags).to include 'test_tag'
      end

      context 'git archive supported' do
        before do
          git(component.origin) { `git config daemon.uploadarch true` }
        end

        it 'should return valid contents of file from remote repository' do
          contents = repository.file_contents('Compoundfile', 'test_tag')
          expect(contents).to eq 'name :test123'
        end

        it 'provides access to component remote manifest' do
          component_source = remote
          component = Component.new(:test) do
            branch 'master'
            source component_source
            destination '/test_destination'
          end

          expect(component.manifest).to be_instance_of Manifest
        end
      end

      context 'git archive not supported' do
        it 'should raise if file is unreachable' do
          expect do
            repository.file_contents('Compoundfile', 'test_tag')
          end.to raise_error FileUnreachableError
        end
      end

      after do
        Process.kill('TERM', daemon)
      end
    end
  end
end
