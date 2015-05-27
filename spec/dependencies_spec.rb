# GitCompound
#
module GitCompound
  describe Component do
    before do
      # Leaf component
      #
      leaf_component_dir = "#{@dir}/leaf_component.git"
      Dir.mkdir(leaf_component_dir)

      git(leaf_component_dir) do
        git_init
        git_add_file('test') { 'test' }
        git_commit('initial commit')
        git_tag('v1.0', 'version 1.0')
      end

      # Dependent compontent 1
      #
      @dependent_component_1_dir = "#{@dir}/dependent_component_1.git"
      Dir.mkdir(@dependent_component_1_dir)

      git(@dependent_component_1_dir) do
        git_init
        git_add_file('.gitcompound') do
          'name :dependent_component_1'
        end
        git_commit('gitcompound commit')
        git_tag('v0.1', 'version 0.1')
        git_add_file('version_1.1') { 'v1.1' }
        git_commit('v1.1 commit')
        git_tag('v1.1', 'version 1.1')
        git_add_file('version_1.2') { 'v1.2' }
        git_edit_file('.gitcompound') do
          <<-END
            name :dependent_component_1

            component :dependent_leaf_1 do
              version '1.0'
              source  '#{leaf_component_dir}'
              destination 'd'
            end

            component :dependent_leaf_2 do
              version '1.0'
              source  '#{leaf_component_dir}'
              destination 'd'
            end
          END
        end
        git_commit('v1.2 commit')
        git_tag('v1.2', 'version 1.2')
      end

      # Dependent compontent 2
      #
      @dependent_component_2_dir = "#{@dir}/dependent_component_2.git"
      Dir.mkdir(@dependent_component_2_dir)

      git(@dependent_component_2_dir) do
        git_init
        git_add_file('Compoundfile') do
          'name :dependent_component_2'
        end
        git_commit('compoundfile commit')
        git_tag('v0.1', 'version 0.1')
        git_edit_file('Compoundfile') do
          <<-END
            name :dependent_component_2

            component :dependent_leaf_1_1 do
              version '1.0'
              source  '#{leaf_component_dir}'
              destination 'd'
            end
          END
        end
        git_commit('v1.1 commit')
        git_tag('v1.1', 'version 1.1')
        git_edit_file('Compoundfile') do
          <<-END
            name :dependent_component_2
          END
        end
        git_commit('v1.2 commit')
        git_tag('v1.2', 'version 1.2')
      end

      # Base component
      #
      @base_component_dir = "#{@dir}/base_component.git"
      Dir.mkdir(@base_component_dir)

      git(@base_component_dir) do
        git_init
        git_add_file('Compoundfile') do
          <<-END
            name :test_component
            component :dependent_component_1 do
              version "~>1.1"
              source '#{@dependent_component_1_dir}'
              destination '#{@dir}/compound/component_1'
            end
            component :dependent_component_2 do
              version "1.1"
              source '#{@dependent_component_2_dir}'
              destination '#{@dir}/compound/component_2'
            end
          END
        end
        git_commit('compoundfile commit')
      end

      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(manifest_contents)
    end

    it 'should load all dependencies' do
      expect(@manifest.components.count).to eq 2
    end

    it 'should set valid names for dependent components' do
      expect(@manifest.components).to include(:dependent_component_1)
      expect(@manifest.components).to include(:dependent_component_2)
    end

    it 'should set valid sources for dependent components' do
      component_1_source = @manifest.components[:dependent_component_1].source
      component_2_source = @manifest.components[:dependent_component_2].source
      expect(component_1_source).to eq @dependent_component_1_dir
      expect(component_2_source).to eq @dependent_component_2_dir
    end

    it 'it should process dependent components dependencies' do
      @manifest.process_dependencies
      dependent_components =
        @manifest.components[:dependent_component_1].manifest.components
      expect(dependent_components.count).to eq 2
      expect(dependent_components).to include(:dependent_leaf_1)
      expect(dependent_components).to include(:dependent_leaf_2)
    end

    it 'should load dependent component_2 from valid ref' do
      @manifest.process_dependencies
      dependent_components =
        @manifest.components[:dependent_component_2].manifest.components
      expect(dependent_components.count).to eq 1
      expect(dependent_components).to include(:dependent_leaf_1_1)
    end
  end
end
