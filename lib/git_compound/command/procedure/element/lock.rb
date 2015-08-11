module GitCompound
  module Command
    module Procedure
      module Element
        # Lock mixin
        #
        module Lock
          attr_reader :lock, :lock_new

          def initialize(args)
            @lock     = GitCompound::Lock.new
            @lock_new = GitCompound::Lock.new.clean
            super
          end
        end
      end
    end
  end
end
