describe GitCompound do
  describe '#build' do
    before do
      git_build_test_environment!
      @components = git_test_env_components
      GitCompound.build("#{@base_component_dir}/Compoundfile")
    end

    pending 'todo' do
      fail
    end
  end
end
