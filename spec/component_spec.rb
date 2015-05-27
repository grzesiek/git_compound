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
        git_tag('v1.1.8', 'version 1.1.8')
        git_tag('v2.0', 'version 2.0')
      end

      component_dir = @component_dir
      @component = Component.new(:test_component) do
        version '~>1.1'
        source component_dir
        destination 'some destination'
      end
    end

    it 'should access component repository refs' do
      refs = @component.repository.refs
      expect(refs[0]).to include('master')
      expect(refs[1]).to include('v0.1')
      expect(refs[3]).to include('v0.2')
    end

    it 'should access component repository versions' do
      versions = @component.repository.versions
      expect(versions).to include '0.1'
      expect(versions).to include '0.2'
      expect(versions).to_not include '0.1^{}'
      expect(versions).to_not include '0.2^{}'
    end

    it 'should access component repository branches' do
      versions = @component.repository.branches
      expect(versions).to include :master
    end

    it 'should match version and ref correctly' do
      expect(@component.lastest_matching_ref).to eq 'v1.1.8'
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
