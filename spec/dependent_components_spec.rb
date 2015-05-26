# GitCompound
#
module GitCompound
  describe Component do
    before do
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
        git_commit('Compoundfile commit')
      end

      # Base component
      #
      @base_component_dir = "#{@dir}/base_component.git"
      Dir.mkdir(@base_component_dir)

      git(@base_component_dir) do
        git_init
        git_add_file('Compoundfile') do
          'name :test_component'
          'component :dependent_component_1 do'
          '  version "~>1.1"'
          "  source '#{@dependent_component_1_dir}'"
          "  destination '#{@dir}/compound/component_1'"
          'end'
          'component :dependent_component_2 do'
          '  version "~>2.0"'
          "  source '#{@dependent_component_2_dir}'"
          "  destination '#{@dir}/compound/component_2'"
          'end'
        end
        git_commit('compoundfile commit')
      end
    end
  end
end
