# GitCompound
#
module GitCompound
  describe Component do
    describe Component::Source do
      let!(:leaf_component_1) { create_leaf_component_1 }
      before do
        git(leaf_component_1.origin) do
          leaf_component_1.add_metadata(
            tag_1_1_8: git_tag('v1.1.8', 'version 1.1.8')
          )
          git_tag('v2.0', 'version 2.0')
          leaf_component_1.add_metadata(
            tag_5_10_20: git_tag('5.10.20.pre.rc1', 'different format tag')
          )
        end
      end

      let(:test_component) do
        component_dir = leaf_component_1.origin
        Component.new(:test_component) do
          version '~>1.1'
          source component_dir
          destination '/test_component_destination'
        end
      end

      subject { test_component.source }

      it 'should access component repository refs' do
        refs = subject.repository.refs
        expect(refs[0]).to include('master')
        expect(refs[1]).to include('5.10.20.pre.rc1')
        expect(refs[3]).to include('v1.0')
      end

      it 'should access component repository versions' do
        versions = subject.repository.versions
        expect(versions).to include '1.0'
        expect(versions).to include '2.0'
        expect(versions).to_not include '1.0^{}'
        expect(versions).to_not include '2.0^{}'
      end

      it 'should access component repository branches' do
        versions = subject.repository.branches
        expect(versions).to include 'master'
      end

      it 'should match version and ref correctly' do
        expect(subject.version.sha).to eq leaf_component_1.metadata[:tag_1_1_8]
      end

      it 'should match version in different format' do
        version_strategy =
          Component::Version::GemVersion.new(subject.repository,
                                             '5.10.20.pre.rc1')
        expect(version_strategy.sha).to eq leaf_component_1.metadata[:tag_5_10_20]
      end

      it 'should be properly cloned into destination' do
        destination = "#{@dir}/#{test_component.path}"
        subject.clone(destination)
        expect(File.exist?("#{destination}/leaf_component_1")).to be true
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
end
