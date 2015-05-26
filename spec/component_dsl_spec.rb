# GitCompound
#
module GitCompound
  describe Component do
    before do
      @component_dir = "#{@dir}/component.git"
      Dir.mkdir(@component_dir)

      git(@component_dir) do
        git_init
      end
    end

    context 'valid DSL' do
      before do
        component_dir = @component_dir
        @component = Component.new(:test_component) do
          version '~>1.1'
          source component_dir
          destination '/some/destination'
        end
      end

      it 'should set version parameter' do
        expect(@component.version).to eq '~>1.1'
      end

      it 'should set source parameter' do
        expect(@component.source).to eq @component_dir
      end

      it 'should set destination parameter' do
        expect(@component.destination).to eq '/some/destination'
      end
    end

    context 'invalid DSL' do
      it 'should raise if sha is invalid' do
        expect do
          component_dir = @component_dir
          Component.new(:test_component) do
            sha '~>1.1'
            source component_dir
            destination '/some/destination'
          end
        end.to raise_error CompoundSyntaxError
      end

      it 'should raise if branch and sha is set' do
        expect do
          component_dir = @component_dir
          Component.new(:test_component) do
            sha '9b09e513a7929dfbfcff1990a6207228e79ab451'
            branch 'feature/something'
            source component_dir
            destination '/some/destination'
          end
        end.to raise_error CompoundSyntaxError
      end
    end
  end
end
