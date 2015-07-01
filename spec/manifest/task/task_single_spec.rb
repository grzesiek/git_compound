# GitCompound
#
module GitCompound
  describe Task::TaskSingle do
    before do
      git_build_test_environment!

      manifest = git_base_component_manifest
      @task = Task::TaskSingle.new(:task_base_manifest, manifest) do |dir, manifest|
        puts "dir: #{dir}"
        puts "manifest name: #{manifest.name}"
      end
    end

    it 'should execute task for manifest' do
      expect{ @task.execute }.to output(
        "dir: #{@dir}\n"                          \
        "manifest name: base_component\n"         \
      ).to_stdout
    end
  end
end
