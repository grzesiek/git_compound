# GitCompound
#
module GitCompound
  describe Component do
    before do
      @component_dir = "#{@dir}/component.git"
      Dir.mkdir(@component_dir)
      git(@component_dir) do
        git_init
        git_add_file('test') { 'Initial file' }
        git_commit('initial commit')
        git_tag('v1.1', 'version 1.1')
      end
      component_dir = @component_dir
      @component = Component.new(:test_component) do
        version '~>1.1'
        source component_dir
        destination 'some destination'
      end
    end

    context 'manifest is available' do
      context 'manifest is stored in Compoundfile file' do
        before do
          git(@component_dir) do
            git_add_file('Compoundfile') { 'name :test_component_1' }
            git_commit('compoundfile commit')
            # we need to bump version and it should satisfy ~>1.1
            git_tag('v1.2', 'version 1.2')
          end
        end

        it do
          manifest = @component.manifest
          expect(manifest).to be_instance_of Manifest
          expect(@component.manifest.name).to eq :test_component_1
        end
      end

      context 'manifest is stored in .gitcompound file' do
        before do
          git(@component_dir) do
            git_add_file('.gitcompound') { 'name :test_component_2' }
            git_commit('.gitcompound commit')
            git_tag('v1.2', 'version 1.2')
          end
        end

        it do
          expect(@component.manifest).to be_instance_of Manifest
          expect(@component.manifest.name).to eq :test_component_2
        end
      end
    end

    context 'manifest file is not found' do
      it 'should return nil if manifest is not found' do
        expect(@component.manifest).to eq nil
      end
    end
  end
end
