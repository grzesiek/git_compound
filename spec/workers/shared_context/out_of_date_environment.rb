shared_context 'out of date environment' do
  before do
    # Build manifest
    #
    git_build_test_environment!
    GitCompound.build("#{@base_component_dir}/Compoundfile")
    @lock = GitCompound::Lock.new

    # Create new component
    #
    @new_component_dir = "#{@dir}/new_component.git"
    Dir.mkdir(@new_component_dir)
    git(@new_component_dir) do
      git_init
      git_add_file('new_component_file') { 'new_component_test_file' }
      git_commit('1.0 commit')
      git_tag('1.0', 'version 1.0')
    end

    # Update component_1 source repository
    #
    git(@component_1_dir) do
      git_add_file('new_component_1_file') { 'new_file_contents' }
      git_edit_file('.gitcompound') do
        <<-END
          name :component_1

          component :leaf_component_1 do
            version '1.0'
            source  '#{@leaf_component_1_dir}'
            destination '/leaf_component_1_destination'
          end

          component :new_component do
            version '1.0'
            source '#{@new_component_dir}'
            destination '/new_component_destination'
          end
        END
      end
      git_commit('2.0 commit')
      git_tag('2.0', 'version 2.0')
    end

    # Create new manifest manifest
    #
    updated_manifest = <<-EOM
      name :base_component

      component :component_1 do
        version "2.0"
        source '#{@component_1_dir}'
        destination '/component_1'
      end

      task :base_component_first_task do
        $stderr.puts 'base_component_first_task'
      end
    EOM

    # And save it as base_component manifest
    #
    git(@base_component_dir) do
      git_edit_file('Compoundfile') { updated_manifest }
    end

    @manifest = git_base_component_manifest
  end
end
