# GitCompound
#
module GitCompound
  describe Repository do
    describe '#untracked_files?' do
      before do
        @repository_dir = "#{@dir}/tmp_test_repository"
        Dir.mkdir(@repository_dir)

        git(@repository_dir) do
          git_init
          git_add_file('first_file') { 'first file contents' }
          git_commit('initial commit')
        end

        @repository = Repository::RepositoryLocal.new(@repository_dir)
      end

      context 'does not have untracked files' do
        it 'does not detect untracked files' do
          expect(@repository).to_not be_untracked_files
        end
      end

      context 'has untracked files' do
        before do
          Dir.chdir(@repository_dir) do
            File.open('first_untracked', 'w') { |f| f.write 'first_untracked contents' }
            File.open('second_untracked', 'w') { |f| f.write 'second_untracked contents' }
            Dir.mkdir('untracked_directory')
            FileUtils.touch('untracked_directory/first_file')
            FileUtils.touch('untracked_directory/second_file')
          end
        end

        context '#untracked_files? invoked without parameters' do
          it 'detects utracked files' do
            expect(@repository).to be_untracked_files
          end
        end

        context '#untracked_files? invoked with parametr including excluded files' do
          it 'returns false if all untracked files excluded' do
            all = %w( first_untracked second_untracked untracked_directory )
            untracked = @repository.untracked_files?(all)
            expect(untracked).to be false
          end

          it 'returns true if not all untracked files excluded' do
            untracked = @repository.untracked_files?(['first_untracked'])
            expect(untracked).to be true
          end
        end
      end
    end
  end
end
