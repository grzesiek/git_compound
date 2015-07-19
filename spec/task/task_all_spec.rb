# GitCompound
#
module GitCompound
  describe Task::TaskAll do
    before do
      git_build_test_environment!

      base_manifest = git_base_component_manifest
      @task = Task::TaskAll.new(:task_for_all_components,
                                base_manifest) do |dir, component|
        puts "dir: #{dir}"
        puts "component name: #{component.name}"
      end
    end

    it 'should reach all components' do
      pattern =
        'dir: /[^ ]+/component_1\n'                               \
        'component name: component_1\n'                           \
        'dir: /[^ ]+/leaf_component_1_destination\n'              \
        'component name: leaf_component_1\n'                      \
        'dir: /[^ ]+/component_1/leaf_component_2_destination\n'  \
        'component name: leaf_component_2\n'                      \
        'dir: /[^ ]+/component_2\n'                               \
        'component name: component_2\n'                           \
        'dir: /[^ ]+/leaf_component_3_destination\n'              \
        'component name: leaf_component_3'

      expect { @task.execute }.to output(/#{pattern}/).to_stdout
    end
  end
end
