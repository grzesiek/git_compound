# Git compound
#
module GitCompound
  describe Worker::TaskRunner do
    before do
      git_build_test_environment!

      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(manifest_contents)
    end

    it 'should visit all tasks in reverse order' do
      expect { @manifest.process(described_class.new) }
        .to output(
          "component_1_tasks for leaf_component_1\n" \
          "component_1_tasks for leaf_component_2\n" \
          "component_2_task\n"                       \
          "base_component_second_tasks for component_1\n" \
          "base_component_second_tasks for component_2\n" \
          "base_component_first_task\n"
        ).to_stdout
    end
  end
end
