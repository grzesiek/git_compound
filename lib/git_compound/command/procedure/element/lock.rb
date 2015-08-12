module GitCompound
  module Command
    module Procedure
      module Element
        # Lock mixin
        #
        module Lock
          def initialize(args)
            @lock     = GitCompound::Lock.new
            @lock_new = GitCompound::Lock.new.clean

            super
          end

          def locked?
            GitCompound::Lock.exist?
          end
        end
      end
    end
  end
end
