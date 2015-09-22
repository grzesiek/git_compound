# GitCompound
#
module GitCompound
  describe Component do
    describe '#remove!' do
      let!(:component_2) { create_component_2 }

      let(:component) do
        component_dir = component_2.origin
        Component.new(:component_2) do
          version '0.1'
          source component_dir
          destination '/component_2_destination'
        end
      end

      let(:destination) { "#{@dir}/#{component.path}" }

      before { component.build! }

      subject { -> { component.remove! } }

      it 'should remove component directory' do
        subject.call
        expect(FileTest.exist?(destination)).to be false
      end

      context 'component directory is invalid' do
        it 'should raise if path contains preceding /' do
          allow(component).to receive(:path) { '/tmp/non_existent' }
          expect { subject.call }.to raise_error(GitCompoundError, /Risky directory/)
        end

        it 'should raise if path contains ..' do
          allow(component).to receive(:path) { 'tmp/non_existent/../diectory' }
          expect { subject.call }.to raise_error(GitCompoundError, /Risky directory/)
        end

        it 'should raise if path does not exist' do
          allow(component).to receive(:path) { 'tmp/non_existent' }
          expect { subject.call }.to raise_error(GitCompoundError, /Not a directory/)
        end
      end
    end
  end
end
