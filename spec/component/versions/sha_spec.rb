# GitCompound
#
module GitCompound
  describe Component::Version::SHA do
    let!(:component_2) { create_component_2 }
    let(:repository) { Repository::RepositoryLocal.new(component_2.origin) }

    context 'repository contains valid sha' do
      before do
        repository.checkout(component_2.metadata[:tag_v1_2_sha])
      end

      subject do
        Component::Version::SHA.new(repository, component_2.metadata[:tag_v1_2_sha])
      end

      it 'reaches valid sha' do
        expect(subject.reachable?).to be true
      end

      it 'returns matching symbolic ref' do
        expect(subject.ref).to eq 'master'
      end

      it 'matches head in repository' do
        head = git(component_2.origin) { git_head_sha }
        expect(head).to eq subject.sha
      end
    end
  end
end
