# GitCompound
#
module GitCompound
  describe Worker::ConflictingDependencyChecker do
    before do
      git_build_test_environment!

      component_dir = @base_component_dir
      @component = Component.new(:base_component) do
        branch 'master'
        source component_dir
        destination '/some/destinaton'
      end
    end

    context 'conflicting depenendecy does not exist' do
      it 'should not raise error' do
        expect { @component.process(described_class.new) }
          .to_not raise_error
      end
    end

    context 'conflicting dependency exists' do
      before do
        git(@leaf_component_3_dir) do
          git_tag('2.0', 'version 2.0')
        end

        git(@component_1_dir) do
          git_edit_file('.gitcompound') do
            <<-END
              name :component_1

              component :leaf_component_1 do
                version '1.0'
                source  '#{@leaf_component_1_dir}'
                destination '/leaf_component_1_destination'
              end

              component :leaf_component_3 do
                version '~>2.0'   ### <-- version conflict (vide component 2)
                source  '#{@leaf_component_3_dir}'
                destination '/leaf_component_3_destination'
              end
            END
          end
          git_commit('.gitcompound with conflicting dependency')
          git_tag('v1.3', 'version 1.3')
        end
      end

      it 'should raise error when conflicting depenendecy is found' do
        expect { @component.process(described_class.new) }
          .to raise_error ConflictingDependencyError
      end
    end
  end
end
