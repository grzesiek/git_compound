# GitCompound
#
module GitCompound
  describe Worker::NameConstraintChecker do
    let!(:components) { create_all_components! }
    let(:base_component_path) { base_component_path! }

    let(:component) do
      component_dir = base_component_path
      Component.new(:base_component) do
        branch 'master'
        source component_dir
        destination '/some/destinaton'
      end
    end

    context 'component and its manifest names matches' do
      it 'should not raise error' do
        expect { component.process(described_class.new) }
          .to_not raise_error
      end
    end

    context 'component and its manifest names differ' do
      before do
        git(components[:component_1].origin) do
          git_edit_file('.gitcompound') do
            <<-END
              name :component_1_invalid # <-- invalid name constraint

              component :leaf_component do
                version '1.0'
                source  '#{components[:leaf_component_1].origin}'
                destination '/leaf_component_1_destination'
              end
            END
          end
          git_commit('.gitcompound with invalid name of component 1')
          git_tag('v1.3', 'version 1.3')
        end
      end

      it 'should raise error when component and its manifest names differ' do
        expect { component.process(described_class.new) }
          .to raise_error NameConstraintError
      end
    end
  end
end
