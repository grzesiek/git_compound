# GitCompound
module GitCompound
  describe Manifest do
    before do
      @valid_contents = <<-END
        name :test_project

        component :test_component do |c|
          c.version     = '~>1.1'
          c.source      = 'git@github.com:test_account/repo1/core_module1.git'
          c.destination = 'application/modules/core_module1'
        end

        task :first_task_name do
        end

        # task :each_task, :each do |t|
        #   t.exclude :a
        #   t.script do
        #     puts '123'
        #   end
        # end
      END

      @manifest = Manifest.new(@valid_contents)
    end

    it 'should return instance of Manifest' do
      expect(@manifest).to be_an_instance_of Manifest
    end

    it 'should not raise error if content is valid' do
      expect do
        Manifest.new(@valid_contents)
      end.to_not raise_error
    end

    it 'should raise exception if syntax is invalid' do
      expect do
        Manifest.new('non_existent_method')
      end.to raise_error CompoundSyntaxError
    end

    it 'should delegate name method' do
      expect(@manifest.name).to eq :test_project
    end

    it 'should delegate components method' do
      expect(@manifest.components).to include(:test_component)
    end

    it 'should delegate tasks method' do
      expect(@manifest.tasks).to include(:first_task_name)
    end
  end
end
