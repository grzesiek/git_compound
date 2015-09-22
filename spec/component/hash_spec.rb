# GitCompound
#
module GitCompound
  describe Component do
    describe '#to_hash' do
      let!(:component_2) { create_component_2 }

      let(:component) do
        component_dir = component_2.origin
        Component.new(:component_2) do
          version '=1.2'
          source component_dir
          destination '/component_2_test_destination'
        end
      end

      subject { component.to_hash }

      it 'should return valid hash' do
        expect(subject).to eq(
          name: :component_2,
          sha: component_2.metadata[:tag_v1_2_sha],
          source: component_2.origin,
          destination: 'component_2_test_destination/'
        )
      end
    end
  end
end
