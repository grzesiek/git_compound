# GitCompound
#
module GitCompound
  describe Repository::RepositoryRemote do
    describe Repository::RemoteFile::GithubStrategy do
      before do
        @component = Component.new(:git_compound) do
          branch 'master'
          source 'https://github.com/grzesiek/git_compound'
          destination 'test_git_compound_github_strategy/'
        end
        @repository = @component.source.repository
      end

      it 'should contain valid ref (first release)' do
        expect(@repository.ref_exists?('v0.0.1')).to be true
      end

      it 'should return valid contents of file from remote repository' do
        contents = @repository.file_contents('git_compound.gemspec', 'v0.0.1')
        expect(contents).to include "spec.version       = '0.0.1'"
      end

      it 'should be able to create instance of manifest' do
        manifest = @component.manifest
        expect(manifest).to be_an_instance_of Manifest
        expect(manifest.name).to eq :git_compound
      end
    end
  end
end
