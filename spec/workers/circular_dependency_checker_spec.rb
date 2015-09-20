# GitCompound
#
module GitCompound
  describe Worker::CircularDependencyChecker do
    let!(:components) { create_all_components! }
    let(:manifest) { manifest! }
    let(:base_component_path) { base_component_path! }

    context 'circular depenendecy does not exist' do
      it 'should not raise error' do
        expect { manifest.process(described_class.new) }
          .to_not raise_error
      end
    end

    context 'circular dependency exists' do
      before do
        git(components[:leaf_component_3].origin) do
          git_add_file('Compoundfile') do
            <<-END
              name :leaf_component_3

              component :base_component do
                branch 'master'
                source '#{base_component_path}'
                destination '/destination'
              end
            END
          end
          git_commit('Compoundfile with circular dependency to base component')
          git_tag('1.1', '1.1 version tag')
        end
      end

      it 'should raise error when circular depenendecy is found' do
        expect { manifest.process(described_class.new) }
          .to raise_error CircularDependencyError
      end
    end
  end
end
