# GitCompound
#
module GitCompound
  describe Command::Procedure::Procedure do
    describe 'options' do
      context 'parameters invalid' do
        let(:test_procedure) do
          # Testpocedure mock
          #
          class TestProcedure < described_class
            include Command::Procedure::Element::Parameter
          end
        end

        subject { test_procedure.new(invalid_parameter: false) }

        pending 'raises error' do
          expect { described_class.new(invalid_parameter: false) }
            .to raise_error(UnknownArgumentError, /Unknown parameter/)
        end
      end

      context 'parameters are valid' do
        before do
          allow(described_class)
            .to receive(:parameters).and_return(valid_parameter: true)
        end

        it 'does not raise error if valid parameter is supplied' do
          expect { described_class.new(valid_parameter: true) }.to_not raise_error
        end

        it 'does not raise error if valid parameter is not supplied' do
          expect { described_class.new({}) }.to_not raise_error
        end
      end

      context 'procedure has subprocedures with parameters' do
        let(:test_procedure) do
          # TestSubprocedure mock
          #
          class TestSubprocedure < described_class
            include Command::Procedure::Element::Parameter

            add_parameter :first_parameter, type: :boolean, scope: :global
            add_parameter :second_parameter, type: :string
          end

          # TestProcedure mock
          #
          class TestProcedure < described_class
            include Command::Procedure::Element::Subprocedure
            include Command::Procedure::Element::Parameter

            add_parameter :my_parameter, type: :integer
            add_subprocedure :sub, TestSubprocedure
          end

          TestProcedure
        end

        subject { test_procedure }

        it 'makes subprocedure global options available in procedure' do
          expect(subject.options).to include :first_parameter, :my_parameter
        end

        it 'ensures that local options are not available in parent procedure' do
          expect(subject.options).to_not include :second_parameter
        end
      end
    end
  end
end
