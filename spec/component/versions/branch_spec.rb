# GitCompound
#
module GitCompound
  describe Component::Version::Branch do
    before do
      git_create_component_2
      @repository = Repository::RepositoryLocal.new(@component_2_dir)
    end

    context 'repository contains valid branch' do
      before do
        @version =
          Component::Version::Branch.new(@repository, 'master')
      end

      it 'reaches valid branch' do
        expect(@version.reachable?).to be true
      end

      it 'returns branch as ref' do
        expect(@version.ref).to eq 'master'
      end
    end

    context 'repository does not contain valid branch' do
      before do
        @version =
          Component::Version::Branch.new(@repository, :non_existent)
      end

      it 'indicates that branch is not reachable' do
        expect(@version.reachable?).to be false
      end
    end
  end
end
