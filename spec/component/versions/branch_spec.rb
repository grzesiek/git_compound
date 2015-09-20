# GitCompound
#
module GitCompound
  describe Component::Version::Branch do
    let!(:component_2) { create_component_2 }
    let(:repository) { Repository::RepositoryLocal.new(component_2.origin) }

    context 'repository contains valid branch' do
      subject do
        Component::Version::Branch.new(repository, 'master')
      end

      it 'reaches valid branch' do
        expect(subject.reachable?).to be true
      end

      it 'returns branch as ref' do
        expect(subject.ref).to eq 'master'
      end
    end

    context 'repository does not contain valid branch' do
      subject do
        Component::Version::Branch.new(repository, :non_existent)
      end

      it 'indicates that branch is not reachable' do
        expect(subject.reachable?).to be false
      end
    end
  end
end
