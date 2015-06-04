module GitCompound
  describe Worker::PrettyPrint do
    before do
      git_build_test_environment!

      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(manifest_contents)
    end

    it 'should pretty-print dependency tree' do
      expect { @manifest.process(Worker::PrettyPrint) }
        .to output("component").to_stdout
    end
  end
end
