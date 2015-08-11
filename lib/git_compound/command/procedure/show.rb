module GitCompound
  module Command
    module Procedure
      # Show command procedure class
      #
      class Show < Procedure
        include Element::Manifest

        def initialize(args)
          super
        end

        def execute
          Logger.info 'Processing components list ...'
          show
        end

        def show
          @manifest.process(
            Worker::CircularDependencyChecker.new,
            Worker::PrettyPrint.new)
        end
      end
    end
  end
end
