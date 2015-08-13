module GitCompound
  module Command
    module Procedure
      # Abstract Procedure class
      #
      class Procedure
        def initialize(_opts)
        end

        # Method with additional messages etc.
        #
        def execute!
          execute
        end

        # Main procedure entry point
        #
        def execute
          raise NotImplementedError
        end

        # Valid options available for this
        # procedure, see Element::Parameter
        #
        def self.options
          {}
        end

        # Name of procedure
        #
        def self.to_s
          name.split('::').last.downcase
        end
      end
    end
  end
end
