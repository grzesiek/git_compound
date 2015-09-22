# GitCompound
#
module GitCompound
  describe Command::Procedure::Procedure do
    describe 'steps' do
      subject { -> { test_procedure.new(opt: 123).execute } }

      describe 'valid order of steps' do
        let(:test_procedure) do
          # TestProcedure
          #
          class TestProcedureOrder < described_class
            step(:print_test_1) { $stderr.print 'test_1' }
            step(:print_space)  { $stderr.print ' ' }
            step(:print_test_2) { $stderr.print 'test_2' }
          end

          TestProcedureOrder
        end

        it { is_expected.to output(/test_1 test_2/).to_stderr }
      end

      describe 'usage of options' do
        let(:test_procedure) do
          # TestProcedure
          #
          class TestProcedureOpts < described_class
            include Command::Procedure::Element::Option
            add_parameter :opt, type: String
            step(:print_opt) { $stderr.print @opts[:opt] }
          end

          TestProcedureOpts
        end

        it { is_expected.to output(/123/).to_stderr }
      end

      describe 'usage of instance variables' do
        let(:test_procedure) do
          # TestProcedure
          #
          class TestProcedureVars < described_class
            def initialize(_opts)
              @test_variable = 'test_variable'
            end

            step(:print_test_variable) { $stderr.print @test_variable }
          end

          TestProcedureVars
        end

        it { is_expected.to output(/test_variable/).to_stderr }
      end
    end
  end
end
