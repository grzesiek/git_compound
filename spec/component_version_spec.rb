# Git Compound
#
module GitCompound
  describe Component::Version do
    before do
      git_create_dependent_component_2
      dependent_component_2_dir = @dependent_component_2_dir

      @component = Component.new(:test_component) do
        version '~>1.1'
        source dependent_component_2_dir
        destination '/some/path'
      end
    end

    it 'should return valid matching versions for requirement' do
      matches = @component.version.matches
      expect(matches).to include '1.1'
      expect(matches).to include '1.2'
    end

    it 'should provide lastest valid matching version' do
      lastest_matching_version = @component.version.lastest_matching
      expect(lastest_matching_version).to eq '1.2'
    end

    it 'should provide valid lastest matching sha' do
      lastest_matching_sha = @component.version.lastest_matching_sha
      expect(lastest_matching_sha).to eq @dependent_component_2_commit_tag_v1_2_sha
    end
  end
end
