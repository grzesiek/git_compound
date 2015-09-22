# Git Compound
#
module GitCompound
  describe Component::Version do
    let!(:component_2) { create_component_2 }

    let!(:test_component) do
      component_2_dir = component_2.origin
      Component.new(:test_component) do
        version '~>1.1'
        source component_2_dir
        destination '/some/path'
      end
    end

    subject { test_component.source.version }

    it 'should return valid matching versions for requirement' do
      expect(subject.matches).to include '1.1'
      expect(subject.matches).to include '1.2'
    end

    it 'should provide lastest valid matching version' do
      expect(subject.ref).to eq 'v1.2'
    end

    it 'should provide valid lastest matching sha' do
      expect(subject.sha).to eq component_2.metadata[:tag_v1_2_sha]
    end
  end
end
