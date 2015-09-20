# GitCompound
module GitCompound
  describe DSL::ManifestDSL do
    let(:contents) do
      <<-END
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
    end

    subject { Manifest.new(contents) }

    it 'does not raise error if content is valid manifest' do
      expect { subject }.to_not raise_error
    end

    it 'raises exception for incorrect manifest' do
      expect { Manifest.new('non_existent_method') }
        .to raise_error NameError
    end

    it 'sets manifest name' do
      expect(subject.name).to eq :test_project
    end

    it 'sets manifest components' do
      expect(subject.components).to include(:test_component)
    end

    it 'sets manifest tasks' do
      expect(subject.tasks).to include(:first_task_name)
      expect(subject.tasks).to include(:foreach_task)
    end

    it 'sets component maintainers' do
      expect(subject.maintainer).to be_instance_of Array
      expect(subject.maintainer).to eq ['Grzegorz Bizon <grzegorz.bizon@ntsn.pl>',
                                        'Grzegorz Bizon <grzesiek@ntsn.pl>']
    end
  end
end
