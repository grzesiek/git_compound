# GitCompound
#
module GitCompound
  describe Component do
    before do
      @component_dir = "#{@dir}/component.git"
      Dir.mkdir(@component_dir)
      git(@component_dir) do
        git_init
      end
      component_dir = @component_dir
      @component = Component.new(:test_component) do
        version '~>1.1'
        source component_dir
        destination 'some destination'
      end
    end

    context 'manifest is available' do
      context 'manifest is stored in Compoundfile' do
        before do
          git(@component_dir) do
            git_add_file('Compoundfile') { 'name "test component"' }
            git_commit('compoundfile commit')
          end
        end

        it do
          manifest = @component.manifest
          expect(manifest).to be_instance_of Manifest
        end
      end

      context 'manifest is stored in .gitcompound file' do
        before do
          git(@component_dir) do
            git_add_file('.gitcompound') { 'name "test component"' }
            git_commit('.gitcompound commit')
          end
        end

        it do
          expect(@component.manifest).to be_instance_of Manifest
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
