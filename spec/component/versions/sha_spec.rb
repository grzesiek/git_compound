# GitCompound
#
module GitCompound
  describe Component::Version::SHA do
    before do
      git_create_component_2
      @repository = Repository::RepositoryLocal.new(@component_2_dir)
    end

    context 'repository contains valid sha' do
      before do
        @version =
          Component::Version::SHA.new(@repository, @component_2_commit_tag_v1_2_sha)
        @repository.checkout(@component_2_commit_tag_v1_2_sha)
        git(@component_2_dir) { puts `git ls-remote ./` }
      end

      it 'reaches valid sha' do
        expect(@version.reachable?).to be true
      end

      it 'returns sha as ref' do
        expect(@version.ref).to eq @component_2_commit_tag_v1_2_sha
      end

      it 'matches head in repository' do
        head = git(@component_2_dir) { git_head_sha }
        expect(head).to eq @version.sha
      end
    end
  end
end
