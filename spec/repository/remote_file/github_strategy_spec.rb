# GitCompound
#
module GitCompound
  describe Repository::RepositoryRemote do
    describe Repository::RemoteFile::GithubStrategy do
      context 'reaching components files' do
        let(:component) do
          Component.new(:git_compound) do
            branch 'master'
            source 'https://github.com/grzesiek/git_compound'
            destination 'test_git_compound_github_strategy/'
          end
        end

        let(:repository) do
          component.source.repository
        end

        it 'should contain valid ref (first release)' do
          expect(repository.tags).to include 'v0.0.1'
        end

        it 'should return valid contents of file from remote repository' do
          contents = repository.file_contents('git_compound.gemspec', 'v0.0.1')
          expect(contents).to include "spec.version       = '0.0.1'"
        end

        it 'should be able to create instance of manifest' do
          manifest = component.manifest
          expect(manifest).to be_an_instance_of Manifest
          expect(manifest.name).to eq :git_compound
        end
      end

      context 'working with source repos' do
        it 'should reach https source' do
          strategy = Repository::RemoteFile::GithubStrategy.new(
            'https://github.com/grzesiek/git_compound',
            'master',
            'Compoundfile'
          )
          expect(strategy).to be_reachable
          expect(strategy.contents).to include 'name :git_compound'
        end

        it 'should reach ssh source (absolute path)' do
          strategy = Repository::RemoteFile::GithubStrategy.new(
            'git@github.com:/grzesiek/git_compound',
            'master',
            'Compoundfile'
          )
          expect(strategy).to be_reachable
          expect(strategy.contents).to include 'name :git_compound'
        end

        it 'should reach ssh source (relative path)' do
          strategy = Repository::RemoteFile::GithubStrategy.new(
            'git@github.com:grzesiek/git_compound',
            'master',
            'Compoundfile'
          )
          expect(strategy).to be_reachable
          expect(strategy.contents).to include 'name :git_compound'
        end
      end
    end
  end
end
