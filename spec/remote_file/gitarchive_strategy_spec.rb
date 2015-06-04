# GitCompound
#
module GitCompound
  describe Repository::RepositoryRemote do
    describe Repository::RemoteFile::GitArchiveStrategy do
      before do
        git_create_leaf_component_1

        git(@leaf_component_1_dir) do
          git_add_file('Compoundfile') { 'name :test123' }
          git_commit('compoundfile commit')
          git_tag('test_tag', 'test_tag')
          git_edit_file('Compoundfile') { 'name :test321' }
          git_commit('compoundfile changed')
          git_tag('second_test_tag', 'second test_tag')

          FileUtils.touch("#{@leaf_component_1_dir}/.git/git-daemon-export-ok")
          @git_daemon_pid = git_expose("#{@leaf_component_1_dir}", 9999)
        end

        @remote = "git://localhost:9999#{@leaf_component_1_dir}"
        @remote_repository = Repository::RepositoryRemote.new(@remote)
      end

      it 'should contain valid test_tag ref' do
        expect(@remote_repository.ref_exists?('test_tag')).to be true
      end

      context 'git archive supported' do
        before do
          git(@leaf_component_1_dir) { `git config daemon.uploadarch true` }
        end

        it 'should return valid contents of file from remote repository' do
          contents = @remote_repository.file_contents('Compoundfile', 'test_tag')
          expect(contents).to eq 'name :test123'
        end
      end

      context 'git archive not supported' do
        it 'should raise if file is unreachable' do
          expect do
            @remote_repository.file_contents('Compoundfile', 'test_tag')
          end.to raise_error FileUnreachableError
        end
      end

      after do
        Process.kill('TERM', @git_daemon_pid)
      end
    end
  end
end
