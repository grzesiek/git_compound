
# GitCompound
#
module GitCompound
  describe Component do
    describe '#build!' do
      let!(:component_2) { create_component_2 }

      let(:test_component) do
        component_dir = component_2.origin
        Component.new(:component_2) do
          version '0.1'
          source component_dir
          destination '/component_2_destination'
        end
      end

      before { test_component.build! }
      subject { "#{@dir}/#{test_component.path}" }

      it 'should clone source to destination' do
        expect(File.directory?(subject + '.git')).to be true
        expect(File.exist?(subject + 'Compoundfile')).to be true
      end

      it 'should checkout valid ref' do
        expect(File.read(subject + 'Compoundfile'))
          .to eq "name :component_2_test\n"
      end
    end
  end
end
