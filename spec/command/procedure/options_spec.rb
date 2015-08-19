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
            include Command::Procedure::Element::Option
          end
        end

        subject { test_procedure.new(invalid_parameter: false) }

        pending 'raises error' do
          expect { described_class.new(invalid_parameter: false) }
            .to raise_error(UnknownArgumentError, /Unknown option/)
        end
      end

      context 'parameters are valid' do
        before do
          allow(described_class)
            .to receive(:options).and_return(valid_parameter: true)
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
            include Command::Procedure::Element::Option

            add_parameter :first_parameter, type: :boolean, scope: :global
            add_parameter :second_parameter, type: :string
            add_argument :first_argument, type: :string
            add_argument :second_argument, type: :string, scope: :global
          end

          # TestProcedure mock
          #
          class TestProcedure < described_class
            include Command::Procedure::Element::Subprocedure
            include Command::Procedure::Element::Option

            add_subprocedure :sub, TestSubprocedure

            add_parameter :my_parameter, type: :integer
            add_argument :third_argument, type: :string
          end

          TestProcedure
        end

        subject { test_procedure }

        it 'makes subprocedure global options available in procedure' do
          expect(subject.options).to \
            eq(first_parameter: { type: :boolean, scope: :global, variant: :parameter },
               second_argument: { type: :string, scope: :global, variant: :argument },
               my_parameter: { type: :integer, variant: :parameter },
               third_argument: { type: :string, variant: :argument })
        end

        it 'ensures that local options are not available in parent procedure' do
          expect(subject.options).to_not include :second_parameter, :first_argument
        end
      end
    end
  end
end
