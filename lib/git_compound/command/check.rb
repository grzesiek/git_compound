module GitCompound
  module Command
    # Check command procedure class
    #
    class Check < Procedure
      include Procedure::Manifest

      def initialize(args)
        super
      end

      def execute
        Logger.info 'Checking dependencies ...'

        manifest.process(
          Worker::CircularDependencyChecker.new,
          Worker::NameConstraintChecker.new,
          Worker::ConflictingDependencyChecker.new)
        self
      end
    end
  end
end
