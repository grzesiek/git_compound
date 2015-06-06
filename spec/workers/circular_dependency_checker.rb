# GitCompound
#
module GitCompound
  describe Worker::CircularDependencyChecker do
    before do
      git_build_test_environment!

      # TODO: add circular dependency somewhere

      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(manifest_contents)
    end

    it 'should raise error if circular depenendecy is found' do
      expect { @manifest.process(described_class) }.to raise_error CircularDependencyError
    end
  end
end
