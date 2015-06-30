# GitCompound
#
module GitCompound
  describe Component::Source do
    describe 'clone options' do
      before do
        git_create_component_2

        component_dir = @component_2_dir
        @component = Component.new(:component_2) do
          tag 'v1.1'
          source component_dir, shallow: true
          destination '/component_2_test_dir'
        end

        @component.build
      end

      it 'should build component' do
        expect(File.directory?('component_2_test_dir')).to be true
        expect(File.exist?('component_2_test_dir/Compoundfile')).to be true
      end

      it 'should have only single commit in cloned repository' do
        commits = git('component_2_test_dir') { git_commits }
        expect(commits.split("\n").count).to eq 1
      end

      it 'should use valid commit' do
        commit = git('component_2_test_dir') { git_commits }
        expect(commit).to include 'v1.1 commit'
      end
    end
  end
end
