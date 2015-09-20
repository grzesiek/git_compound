# GitCompound
#
module GitCompound
  describe Component do
    describe '#ancestors' do
      let!(:base_component) { create_base_component }

      let(:component) do
        component_dir = base_component.origin
        Component.new(:base_component) do
          branch 'master'
          source component_dir
          destination '/some_destination'
        end
      end

      subject { component.ancestors }

      describe 'base component ancestors' do
        it('should be empty array') { expect(subject).to eq [] }
      end

      describe 'leaf component ancestors' do
        let(:component_1) { component.manifest.components[:component_1] }
        let(:leaf_component_1) { component_1.manifest.components[:leaf_component_1] }
        subject { leaf_component_1.ancestors }

        it 'should be array of component instances' do
          expect(subject.all? { |ancestor| ancestor.instance_of?(Component) }).to be true
        end

        it 'should have expected size' do
          expect(subject.size).to be 2
        end
      end
    end
  end
end
