# GitCompound

module GitCompound
  describe GitRepository::RepositoryRemote do
    describe 'remote file in remote repo via git archive strategy' do
      before do
        @repository_dir = "#{@dir}/repo.git"
        Dir.mkdir(@repository_dir)

        git(@repository_dir) do
          git_init
          git_add_file('Compoundfile') { 'name :test123' }
          git_commit('compoundfile commit')
          git_tag('test_tag', 'test_tag')
          git_edit_file('Compoundfile') { 'name :test321' }
          git_commit('compoundfile changed')
          git_tag('second_test_tag', 'second test_tag')

          FileUtils.touch("#{@repository_dir}/.git/git-daemon-export-ok")
          @git_daemon_pid = git_expose("#{@repository_dir}", 9999)
        end

        @remote = "git://localhost:9999#{@repository_dir}"
        @remote_repository = GitRepository::RepositoryRemote.new(@remote)
      end

      it 'should contain valid test_tag ref' do
        expect(@remote_repository.ref_exists?('test_tag')).to be true
      end


      context 'git archive supported' do
        before do
          git(@repository_dir) { `git config daemon.uploadarch true` }
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
