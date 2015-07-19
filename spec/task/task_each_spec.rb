# GitCompound
#
module GitCompound
  describe Task::TaskEach do
    before do
      git_build_test_environment!

      base_manifest = git_base_component_manifest
      @task = Task::TaskEach.new(:task_for_manifest_components,
                                 base_manifest) do |dir, component|
        puts "dir: #{dir}"
        puts "component name: #{component.name}"
      end
    end

    it 'should reach all components' do
      pattern =
        'dir: /[^ ]+/component_1\n'     \
        'component name: component_1\n' \
        'dir: /[^ ]+/component_2\n'     \
        'component name: component_2\n'

      expect { @task.execute }.to output(/#{pattern}/).to_stdout
    end
  end
end
