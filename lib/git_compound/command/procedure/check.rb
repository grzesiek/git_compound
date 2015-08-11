module GitCompound
  module Command
    module Procedure
      # Check command procedure class
      #
      class Check < Procedure
        include Element::Manifest

        def initialize(args)
          super
        end

        def execute
          check
          Logger.info 'OK'
        end

        def check
          Logger.info 'Checking dependencies ...'

          @manifest.process(
            Worker::CircularDependencyChecker.new,
            Worker::NameConstraintChecker.new,
            Worker::ConflictingDependencyChecker.new)
        end
      end
    end
  end
end
