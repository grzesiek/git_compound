# GitCompound
#
module GitCompound
  describe Component do
    describe Manifest do
      let!(:leaf_component_1) { create_leaf_component_1 }

      let(:component) do
        component_dir = leaf_component_1.origin
        Component.new(:test_component) do
          version '~>1.0'
          source component_dir
          destination 'some destination'
        end
      end

      context 'manifest is available' do
        context 'manifest is stored in Compoundfile file' do
          before do
            git(leaf_component_1.origin) do
              git_add_file('Compoundfile') { 'name :test_component_1' }
              git_commit('compoundfile commit')
              # we need to bump version and it should satisfy ~>1.0
              git_tag('v1.1', 'version 1.1')
            end
          end

          it do
            expect(component.manifest).to be_instance_of Manifest
            expect(component.manifest.name).to eq :test_component_1
          end
        end

        context 'manifest is stored in .gitcompound file' do
          before do
            git(leaf_component_1.origin) do
              git_add_file('.gitcompound') { 'name :test_component_2' }
              git_commit('.gitcompound commit')
              git_tag('v1.1', 'version 1.1')
            end
          end

          it do
            expect(component.manifest).to be_instance_of Manifest
            expect(component.manifest.name).to eq :test_component_2
          end
        end
      end

      context 'manifest file is not found' do
        it 'manifest.exists? should return false' do
          expect(component.manifest.exists?).to eq false
        end
      end
    end
  end
end
