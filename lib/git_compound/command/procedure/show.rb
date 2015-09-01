module GitCompound
  module Command
    module Procedure
      # Show command procedure class
      #
      class Show < Procedure
        include Element::Manifest

        def execute!
          Logger.info 'Processing components list ...'
          super
        end

        step :pretty_print do
          @manifest.process(
            Worker::CircularDependencyChecker.new,
            Worker::PrettyPrint.new)
        end
      end
    end
  end
end
