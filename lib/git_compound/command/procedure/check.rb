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
          Logger.info 'Checking dependencies ...'
          check
          Logger.info 'OK'
        end

        def check
          manifest.process(
            Worker::CircularDependencyChecker.new,
            Worker::NameConstraintChecker.new,
            Worker::ConflictingDependencyChecker.new)
          self
        end
      end
    end
  end
end
