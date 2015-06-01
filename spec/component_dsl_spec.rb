# GitCompound
#
module GitCompound
  describe Component do
    before do
      git_create_leaf_component_1
    end

    context 'valid DSL' do
      before do
        component_dir = @leaf_component_1_dir
        @component = Component.new(:test_component) do
          version '~>1.1'
          source component_dir
          destination '/some/destination'
        end
      end

      it 'should set version' do
        expect(@component.version).to be_an_instance_of Component::Version
        expect(@component.version.requirement).to eq '~>1.1'
      end

      it 'should set source parameter' do
        expect(@component.source.location).to eq @leaf_component_1_dir
      end

      it 'should set destination parameter' do
        expect(@component.destination).to eq '/some/destination'
      end
    end

    context 'invalid DSL' do
      it 'should raise if sha is invalid' do
        expect do
          Component.new(:test_component) do
            sha '~>1.1'
          end
        end.to raise_error CompoundSyntaxError
      end

      it 'should raise if branch and sha is set' do
        expect do
          Component.new(:test_component) do
            sha '9b09e513a7929dfbfcff1990a6207228e79ab451'
            branch 'feature/something'
          end
        end.to raise_error CompoundSyntaxError
      end
    end
  end
end
