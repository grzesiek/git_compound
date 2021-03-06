# GitCompound
#
module GitCompound
  describe Component::Version::GemVersion do
    let!(:component_2) { create_component_2 }
    let(:repository) { Repository::RepositoryLocal.new(component_2.origin) }

    context 'repository contains valid ref' do
      subject do
        Component::Version::GemVersion.new(repository, '1.1')
      end

      it 'is able to reach existing tag' do
        expect(subject.reachable?).to be true
      end

      it 'returns tag as ref' do
        expect(subject.ref).to eq 'v1.1'
      end
    end

    context 'repository contains many matching versions' do
      subject do
        Component::Version::GemVersion.new(repository, '>= 0.0')
      end

      it 'is able to reach existing tag' do
        expect(subject.reachable?).to be true
      end

      it 'returns valid matches' do
        expect(subject.matches).to eq ['1.2', '1.1', '0.1']
      end

      it 'recommends lastest available version' do
        expect(subject.lastest_version).to eq '1.2'
      end

      it 'returns lastest version ref' do
        expect(subject.ref).to eq 'v1.2'
      end
    end

    context 'repository does not contain valid sha' do
      subject do
        Component::Version::GemVersion.new(repository, '123.0')
      end

      it 'is able to reach existing tag' do
        expect(subject.reachable?).to be false
      end
    end
  end
end
