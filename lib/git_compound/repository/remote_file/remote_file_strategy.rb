module GitCompound
  module Repository
    class RemoteFile
      # Base interface for strategies
      #
      class RemoteFileStrategy
        def initialize(source, ref, file)
          @source = source
          @ref    = ref
          @file   = file
        end

        def contents
          raise NotImplementedError
        end

        def reachable?
          raise NotImplementedError
        end

        def exists?
          raise NotImplementedError
        end
      end
    end
  end
end
