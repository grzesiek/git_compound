require 'shared_examples/component_builder'

# GitCompound
#
module GitCompound
  describe Worker::ComponentBuilder do
    before do
      git_build_test_environment!
      @components = git_test_env_components
      @manifest.process(described_class.new)
    end

    it_behaves_like 'component builder'
  end
end
