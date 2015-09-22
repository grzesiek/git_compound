# Test Environment Builder
#
# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
module TestEnvBuilder
  def manifest!
    GitCompound::Manifest.new(File.read(manifest_path!))
  end

  def manifest_path!
    "#{base_component_path!}/Compoundfile"
  end

  def base_component_path!
    "#{@dir}/base_component"
  end

  def create_all_components!
    create_base_component

    component_1 = manifest!.components[:component_1]
    component_2 = manifest!.components[:component_2]
    leaf_component_1 = component_1.manifest.components[:leaf_component_1]
    leaf_component_2 = component_1.manifest.components[:leaf_component_2]
    leaf_component_3 = component_2.manifest.components[:leaf_component_3]

    { component_1: component_1,
      component_2: component_2,
      leaf_component_1: leaf_component_1,
      leaf_component_2: leaf_component_2,
      leaf_component_3: leaf_component_3 }
  end

  def create_base_component
    component_1 = create_component_1
    component_2 = create_component_2

    component_1_dst = '/component_1_destination'
    component_2_dst = '/component_2_destination'

    component = git_create_component(base_component_path!) do
      git_init
      git_add_file('Compoundfile') do
        <<-END
          name :base_component
          maintainer 'Grzegorz Bizon <grzegorz.bizon@ntsn.pl>'

          component :component_1 do
            version "~>1.1"
            source '#{component_1.origin}'
            destination '#{component_1_dst}'
          end

          component :component_2 do
            version "1.1"
            source '#{component_2.origin}'
            destination '#{component_2_dst}'
          end

          task :base_component_second_tasks, :each do |dir, component|
            $stderr.puts "base_component_second_tasks for " + component.name.to_s
          end

          task :base_component_first_task do
            $stderr.puts 'base_component_first_task'
          end
        END
      end
      git_commit('compoundfile commit')
    end

    component.add_metadata(component_1: component_1,
                           component_2: component_2)
    component
  end

  def create_component_1
    leaf_1 = create_leaf_component_1
    leaf_2 = create_leaf_component_2

    component = git_create_component("#{@dir}/component_1") do
      git_init
      git_add_file('.gitcompound') do
        'name :component_1'
      end
      git_commit('gitcompound commit')
      git_tag('v0.1', 'version 0.1')
      git_add_file('version_1.1') { 'v1.1' }
      git_commit('v1.1 commit')
      git_tag('v1.1', 'version 1.1')
      git_add_file('version_1.2') { 'v1.2' }
      git_edit_file('.gitcompound') do
        <<-END
          name :component_1

          component :leaf_component_1 do
            version '1.0'
            source  '#{leaf_1.origin}'
            destination '/leaf_component_1_destination'
          end

          component :leaf_component_2 do
            version '1.0'
            source  '#{leaf_2.origin}'
            destination 'leaf_component_2_destination/'
          end

          task :component_1_tasks, :each do |dir, component|
            $stderr.puts "component_1_tasks for " + component.name.to_s +
              " dir: " + dir
          end
        END
      end
      git_commit('v1.2 commit')
      git_tag('v1.2', 'version 1.2')
    end

    component.add_metadata(leaf_component_1: leaf_1, leaf_component_2: leaf_2)
    component
  end

  def create_component_2
    leaf_3 = create_leaf_component_3
    leaf_3_dst = '/leaf_component_3_destination'
    metadata = {}

    component = git_create_component("#{@dir}/component_2") do
      git_init
      git_add_file('Compoundfile') do
        'name :component_2_test'
      end
      git_commit('compoundfile commit')
      git_tag('v0.1', 'version 0.1')
      git_edit_file('Compoundfile') do
        <<-END
          name :component_2
          maintainer 'Grzegorz Bizon <grzesiek@ntsn.pl>'

          component :leaf_component_3 do
            version '~>1.0'
            source  '#{leaf_3.origin}'
            destination '#{leaf_3_dst}'
          end

          task :component_2_task do
            $stderr.puts 'component_2_task'
          end

          task :component_2_leaf_component_3_task, :each do |dir|
            $stderr.puts 'leaf_component_3_dir ' + dir
          end
        END
      end
      git_commit('v1.1 commit')
      git_tag('v1.1', 'version 1.1')
      git_edit_file('Compoundfile') do
        <<-END
          name :component_2
        END
      end
      git_commit('v1.2 commit')

      metadata.store(:tag_v1_2_sha, git_tag('v1.2', 'version 1.2'))
    end

    metadata.store(:leaf_component_3, leaf_3)
    component.add_metadata(metadata)
    component
  end

  def create_leaf_component_3
    git_create_component("#{@dir}/leaf_component_3") do
      git_init
      git_add_file('component') { 'leaf_component_3' }
      git_commit('initial commit')
      git_tag('v1.0', 'version 1.0')
    end
  end

  def create_leaf_component_2
    git_create_component("#{@dir}/leaf_component_2") do
      git_init
      git_add_file('component') { 'leaf_component_2' }
      git_commit('initial commit')
      git_tag('v1.0', 'version 1.0')
    end
  end

  def create_leaf_component_1
    git_create_component("#{@dir}/leaf_component_1") do
      git_init
      git_add_file('leaf_component_1') { 'leaf_component_1_content' }
      git_commit('initial commit')
      git_tag('v1.0', 'version 1.0')
    end
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/MethodLength
