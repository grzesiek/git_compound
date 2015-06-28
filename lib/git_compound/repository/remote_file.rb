module GitCompound
  module Repository
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
        @strategies.each do |remote_file_strategy|
          remote_file = remote_file_strategy.new(@source, @ref, @file)
          next unless remote_file.reachable?
          return remote_file.contents
        end
        raise FileUnreachableError,
              "Couldn't reach file #{@file} after trying #{@strategies.count} stategies"
      end

      def strategies_available
        # Strategies ordered by #reachable? method overhead
        # More general strategies should be placed at lower positions,
        # but this also depends on #reachable? overhead.
        #
        [GithubStrategy,
         GitArchiveStrategy]
      end
    end
  end
end
