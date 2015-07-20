# GitCompound
#
module GitCompound
  describe Logger::Debugger do
    before { GitCompound::Command::Options.verbose = true }
    subject do
      # DebuggerClass for test-only purpose
      class DebuggerTest
        extend Logger::Debugger

        def initialize(str)
          @string = str
        end

        def size
          @string.size
        end

        def sub(str, sub)
          @string.sub(str, sub)
        end

        debug_after(:size) { |ret| "Size: #{ret}" }
        debug_after(:sub)  { |ret, arg1, arg2| "Sub: #{ret}, #{arg1}, #{arg2}" }
      end
      DebuggerTest.new('123456789')
    end

    it 'has debug methods defined' do
      expect(subject.class.methods).to include :debug_before
      expect(subject.class.methods).to include :debug_after
    end

    it 'is able to log return value' do
      expect { subject.size }.to output(/Size: 9/).to_stdout
    end

    it 'logs input values' do
      expect { subject.sub('123', 'xxx') }
        .to output(/Sub: xxx456789, 123, xxx/).to_stdout
    end

    it 'does not change return value' do
      expect(subject.size).to be 9
    end
  end
end
