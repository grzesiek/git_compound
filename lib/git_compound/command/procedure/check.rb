module GitCompound
  module Command
    module Procedure
      # Check command procedure class
      #
      class Check < Procedure
        include Element::Manifest

        def execute!
          super
          Logger.info 'OK'
        end

        step :check_dependencies do
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
