# GitCompound
#
module GitCompound
  describe Component do
    before do
      git_build_test_environment!

      component_dir = @base_component_dir
      @component = Component.new(:base_component) do
        branch 'master'
        source component_dir
        destination 'some destination'
      end
    end

    describe 'base component ancestors' do
      it 'should be empty array' do
        expect(@component.ancestors).to eq []
      end
    end

    describe 'leaf component ancestors' do
      before do
        required_component = @component.manifest.components[:component_1]
        leaf_component = required_component.manifest.components[:leaf_component_1]
        @ancestors = leaf_component.ancestors
      end

      it 'should be array of component instances' do
        expect(@ancestors.all? { |ancestor| ancestor.instance_of?(Component) }).to be true
      end

      it 'should have expected size' do
        expect(@ancestors.size).to be 2
      end
    end
  end
end
