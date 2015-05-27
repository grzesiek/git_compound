module GitCompound
  module GitRepository
    # Remote file loader based on strategies
    #
    class RemoteFile
      def initialize(source, ref, file, strategies = nil)
        @source     = source
        @ref        = ref
        @file       = file
        @strategies = strategies
      end

      def contents
        @strategies ||= strategies_available
        @strategies.each do |strategy|
          begin
            return strategy.new(@source, @ref, @file).contents
          rescue FileUnreachableError
            next
          end
        end
        raise FileUnreachableError,
              "Couldn't reach file #{@file} after trying #{@strategies.count} stategies"
      end

      def strategies_available
        [RemoteFileStrategy::GitArchiveStrategy]
        # GitArchiveStrategy,
        # GitHubStrategy]
      end
    end
  end
end
