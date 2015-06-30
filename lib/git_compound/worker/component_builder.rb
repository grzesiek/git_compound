module GitCompound
  module Worker
    # Worker that builds components
    #
    class ComponentBuilder < Worker
      def initialize
        @print = PrettyPrint.new
      end

      def visit_component(component)
        print 'Building: '
        @print.visit_component(component)

        raise GitCompoundError,
              "Destination directory `#{component.destination_path}` " \
              'already exists !' if component.destination_exists?

        component.build

        raise GitCompoundError,
              "Destination  `#{component.destination_path}` " \
              'verification failed !' unless component.destination_exists?
      end
    end
  end
end
