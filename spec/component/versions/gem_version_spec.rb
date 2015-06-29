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
          Component::Version::GemVersion.new(@repository, '1.1')
      end

      it 'is able to reach existing tag' do
        expect(@version.reachable?).to be true
      end

      it 'returns tag as ref' do
        expect(@version.ref).to eq 'v1.1'
      end
    end

    context 'repository contains many matching versions' do
      before do
        @version =
          Component::Version::GemVersion.new(@repository, '>= 0.0')
      end

      it 'is able to reach existing tag' do
        expect(@version.reachable?).to be true
      end

      it 'returns valid matches' do
        expect(@version.matches).to eq ['1.2', '1.1', '0.1']
      end

      it 'recommends lastest available version' do
        expect(@version.lastest_version).to eq '1.2'
      end

      it 'returns lastest version ref' do
        expect(@version.ref).to eq 'v1.2'
      end
    end

    context 'repository does not contain valid sha' do
      before do
        @version =
          Component::Version::GemVersion.new(@repository, '123.0')
      end

      it 'is able to reach existing tag' do
        expect(@version.reachable?).to be false
      end
    end
  end
end
