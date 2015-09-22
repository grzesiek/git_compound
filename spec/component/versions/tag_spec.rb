# GitCompound
#
module GitCompound
  describe Component::Version::Tag do
    let!(:component_2) { create_component_2 }
    let(:repository) { Repository::RepositoryLocal.new(component_2.origin) }

    context 'repository contains valid tag' do
      subject do
        Component::Version::Tag.new(repository, 'v1.1')
      end

      it 'reaches valid tag' do
        expect(subject.reachable?).to be true
      end

      it 'returns tag as ref' do
        expect(subject.ref).to eq 'v1.1'
      end
    end

    context 'repository does not contain valid tag' do
      subject do
        Component::Version::Tag.new(repository, :non_existent)
      end

      it 'indicates that tag is not reachable' do
        expect(subject.reachable?).to be false
      end
    end
  end
end
