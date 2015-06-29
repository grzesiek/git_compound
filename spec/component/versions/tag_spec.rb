# GitCompound
#
module GitCompound
  describe Component::Version::Tag do
    before do
      git_create_component_2
      @repository = Repository::RepositoryLocal.new(@component_2_dir)
    end

    context 'repository contains valid tag' do
      before do
        @version =
          Component::Version::Tag.new(@repository, 'v1.1')
      end

      it 'reaches valid tag' do
        expect(@version.reachable?).to be true
      end

      it 'returns tag as ref' do
        expect(@version.ref).to eq 'v1.1'
      end
    end

    context 'repository does not contain valid tag' do
      before do
        @version =
          Component::Version::Tag.new(@repository, :non_existent)
      end

      it 'indicates that tag is not reachable' do
        expect(@version.reachable?).to be false
      end
    end
  end
end
