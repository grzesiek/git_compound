# GitCompound
module GitCompound
  describe DSL::ManifestDSL do
    before do
      @manifest_contents = <<-END
        name :test_project

        component :test_component do
          version     '~>1.1'
          source      'git@github.com:test_account/repo1/core_module1.git'
          destination 'application/modules/core_module1'
        end

        task :first_task_name do
        end

        # task :each_task, :each do |t|
        #   exclude :a
        #   script do
        #     puts '123'
        #   end
        # end
      END

      @manifest = Manifest.new(@manifest_contents)
    end

    it 'should not raise error if content is valid manifest' do
      expect do
        Manifest.new(@manifest_contents)
      end.to_not raise_error
    end

    it 'should raise exception for incorrect manifest' do
      expect do
        Manifest.new('non_existent_method')
      end.to raise_error NameError
    end

    it 'should set manifest name' do
      expect(@manifest.name).to eq :test_project
    end

    it 'should set manifest components' do
      expect(@manifest.components).to include(:test_component)
    end

    it 'should set manifest tasks' do
      expect(@manifest.tasks).to include(:first_task_name)
    end
  end
end
