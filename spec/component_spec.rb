# GitCompound
#
module GitCompound
  describe Component do
    before do
      @component_dir = "#{@dir}/component.git"
      Dir.mkdir(@component_dir)

      git(@component_dir) do
        git_init

        git_add_file('Compoundfile') do
          'name "test component"'
        end

        git_commit('compoundfile commit')
        git_tag('v0.1', 'version 0.1')

        git_add_file('second_file') do
          'some second file'
        end

        git_commit('second commit')
        git_tag('v0.2', 'version 0.2')
        git_tag('v1.1', 'version 1.1')
        @git_commit_tag_1_1_8 = git_tag('v1.1.8', 'version 1.1.8')
        git_tag('v2.0', 'version 2.0')
        @git_commit_tag_5_10_20 = git_tag('5.10.20.pre.rc1', 'different format tag')
      end

      component_dir = @component_dir
      @component = Component.new(:test_component) do
        version '~>1.1'
        source component_dir
        destination 'some destination'
      end
    end

    it 'should access component repository refs' do
      refs = @component.source.repository.refs
      expect(refs[0]).to include('master')
      expect(refs[1]).to include('5.10.20.pre.rc1')
      expect(refs[3]).to include('v0.1')
    end

    it 'should access component repository versions' do
      versions = @component.source.repository.versions
      expect(versions).to include '0.1'
      expect(versions).to include '0.2'
      expect(versions).to_not include '0.1^{}'
      expect(versions).to_not include '0.2^{}'
    end

    it 'should access component repository branches' do
      versions = @component.source.repository.branches
      expect(versions).to include 'master'
    end

    it 'should match version and ref correctly' do
      expect(@component.source.version.sha).to eq @git_commit_tag_1_1_8
    end

    it 'should match version in different format' do
      repository = @component.source.repository
      version_strategy = Component::Version::GemVersion.new(repository, '5.10.20.pre.rc1')
      expect(version_strategy.sha).to eq @git_commit_tag_5_10_20
    end

    context 'source repository is unreachable' do
      it do
        expect do
          Component.new(:test_component_3) do
            version '~>1.1'
            source '/some/invalid/path'
            destination 'some destination'
          end
        end.to raise_error RepositoryUnreachableError
      end
    end
  end
end
