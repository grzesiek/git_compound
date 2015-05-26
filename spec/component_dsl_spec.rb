# GitCompound
#
module GitCompound
  describe Component do
    context 'valid DSL' do
      before do
        @component = Component.new(:test_component) do
          version '~>1.1'
          source '/some/source'
          destination '/some/destination'
        end
      end

      it 'should set version parameter' do
        expect(@component.version).to eq '~>1.1'
      end

      it 'should set source parameter' do
        expect(@component.source).to eq '/some/source'
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
            source '/some/source'
            destination '/some/destination'
          end
        end.to raise_error CompoundSyntaxError
      end

      it 'should raise if branch and sha is set' do
        expect do
          Component.new(:test_component) do
            sha '9b09e513a7929dfbfcff1990a6207228e79ab451'
            branch 'feature/something'
            source '/some/source'
            destination '/some/destination'
          end
        end.to raise_error CompoundSyntaxError
      end
    end
  end
end
