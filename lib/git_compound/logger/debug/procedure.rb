module GitCompound
  module Command
    module Procedure
      # Debug cases for Procedure
      #
      class Procedure
        extend Logger::Debugger

        debug_before(:execute_step) do |name|
          "Executing step `#{name}` in `#{self.class}` procedure"
        end
      end
    end
  end
end
