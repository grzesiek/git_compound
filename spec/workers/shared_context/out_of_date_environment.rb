shared_context 'out of date environment' do
  let!(:components) { create_all_components! }

  let(:new_component) do
    new_component_dir = "#{@dir}/new_component.git"
    Dir.mkdir(new_component_dir)
    git(new_component_dir) do
      git_init
      git_add_file('new_component_file') { 'new_component_test_file' }
      git_commit('1.0 commit')
      git_tag('1.0', 'version 1.0')
    end
    new_component_dir
  end

  let(:manifest) { manifest! }
  let(:manifest_path) { manifest_path! }
  let(:base_component_path) { base_component_path! }

  let(:component) { components[:component_1] }
  let(:lock) { GitCompound::Lock.new }

  before do
    # Build manifest
    #
    GitCompound.build(manifest_path)

    # Create new component
    #
    new_component

    # Update component_1 source repository
    #
    git(components[:component_1].origin) do
      git_add_file('new_component_1_file') { 'new_file_contents' }
      git_edit_file('.gitcompound') do
        <<-END
          name :component_1

          component :leaf_component_1 do
            version '1.0'
            source  '#{components[:leaf_component_1].origin}'
            destination '/leaf_component_1_destination'
          end

          component :leaf_component_2 do
            version '1.0'
            source  '#{components[:leaf_component_1].origin}'
            destination 'leaf_component_2_destination/'
          end

          component :new_component do
            version '1.0'
            source '#{new_component}'
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
        source '#{components[:component_1].origin}'
        destination '/component_1_destination'
      end

      task :base_component_first_task do
        $stderr.puts 'base_component_first_task'
      end
    EOM

    # And save it as base_component's manifest
    #
    git(base_component_path) do
      git_edit_file('Compoundfile') { updated_manifest }
    end
  end
end
