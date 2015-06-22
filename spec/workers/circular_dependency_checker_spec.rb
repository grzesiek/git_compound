# GitCompound
#
module GitCompound
  describe Worker::CircularDependencyChecker do
    before do
      git_build_test_environment!

      contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(contents)
    end

    context 'circular depenendecy does not exist' do
      it 'should not raise error' do
        expect { @manifest.process(described_class.new) }
          .to_not raise_error
      end
    end

    context 'circular dependency exists' do
      before do
        git(@leaf_component_3_dir) do
          git_add_file('Compoundfile') do
            <<-END
              name :leaf_component_3

              component :base_component do
                branch 'master'
                source '#{@base_component_dir}'
                destination '/destination'
              end
            END
          end
          git_commit('Compoundfile with circular dependency to base component')
          git_tag('1.1', '1.1 version tag')
        end
      end

      it 'should raise error when circular depenendecy is found' do
        expect { @manifest.process(described_class.new) }
          .to raise_error CircularDependencyError
      end
    end
  end
end
