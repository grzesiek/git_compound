# GitCompound
#
module GitCompound
  describe Worker::NameConstraintChecker do
    before do
      git_build_test_environment!

      component_dir = @base_component_dir
      @component = Component.new(:base_component) do
        branch 'master'
        source component_dir
        destination '/some/destinaton'
      end
    end

    context 'component and its manifest names matches' do
      it 'should not raise error' do
        expect { @component.process(described_class.new) }
          .to_not raise_error
      end
    end

    context 'component and its manifest names differ' do
      before do
        git(@component_1_dir) do
          git_edit_file('.gitcompound') do
            <<-END
              name :component_1_invalid # <-- invalid name constraint

              component :leaf_component do
                version '1.0'
                source  '#{@leaf_component_1_dir}'
                destination '/leaf_component_1_destination'
              end
            END
          end
          git_commit('.gitcompound with invalid name of leaf component 1')
          git_tag('v1.3', 'version 1.3')
        end
      end

      it 'should raise error when component and its manifest names differ' do
        expect { @component.process(described_class.new) }
          .to raise_error NameConstraintError
      end
    end
  end
end
