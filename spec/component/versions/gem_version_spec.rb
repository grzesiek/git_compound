# GitCompound
#
module GitCompound
  describe Component::Version::SHA do
    before do
      git_create_component_2
      @repository = Repository::RepositoryLocal.new(@component_2_dir)
    end
    
    context 'repository contains valid ref' do
      before do
        @version = 
          Component::Version::GemVersion.new(@repository, 'v1.1')
      end

      it 'is able to reach existing tag' do
        expect(@version.reachable?).to be true
      end

      it 'returns tag as ref' do
        expect(@version.ref).to eq 'v1.1'
      end
    end

    context 'repository does not contain valid sha' do
    end
  end 
end
