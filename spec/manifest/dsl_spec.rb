# GitCompound
module GitCompound
  describe DSL::ManifestDSL do
    before do
      @manifest_contents = <<-END
        name :test_project
        maintainer 'Grzegorz Bizon <grzegorz.bizon@ntsn.pl>',
                   'Grzegorz Bizon <grzesiek@ntsn.pl>'

        component :test_component do
          version     '~>1.1'
          source      'git@github.com:test_account/repo1/core_module1.git'
          destination 'application/modules/core_module1'
        end

        task :first_task_name do |dir, component|
          puts dir
        end

        task :foreach_task, :each do |dir, component|
          puts component
        end
      END

      @manifest = Manifest.new(@manifest_contents)
    end

    it 'does not raise error if content is valid manifest' do
      expect do
        Manifest.new(@manifest_contents)
      end.to_not raise_error
    end

    it 'raises exception for incorrect manifest' do
      expect do
        Manifest.new('non_existent_method')
      end.to raise_error NameError
    end

    it 'sets manifest name' do
      expect(@manifest.name).to eq :test_project
    end

    it 'sets manifest components' do
      expect(@manifest.components).to include(:test_component)
    end

    it 'sets manifest tasks' do
      expect(@manifest.tasks).to include(:first_task_name)
      expect(@manifest.tasks).to include(:foreach_task)
    end

    it 'sets component maintainers' do
      expect(@manifest.maintainer).to be_instance_of Array
      expect(@manifest.maintainer).to eq ['Grzegorz Bizon <grzegorz.bizon@ntsn.pl>',
                                          'Grzegorz Bizon <grzesiek@ntsn.pl>']
    end
  end
end
