module GitCompound
  module Repository
    # GitVersion represents tagged version inside Git repository
    #
    class GitVersion
      attr_reader :tag, :sha, :version

      def initialize(tag, sha)
        @tag = tag
        @sha = sha
        @version = tag.sub(/^v/, '')
      end

      def to_gem_version
        Gem::Version.new(@version)
      end

      def valid?
        @tag.match(/^v?#{Gem::Version::VERSION_PATTERN}$/) &&
          !@tag.match(/.*\^\{\}$/) # annotated tag objects
      end

      def <=>(other)
        self.to_gem_version <=> other.to_gem_version
      end

      def ==(other)
        case other
        when String
          version == other
        when GitVersion
          version == other.version
        end
      end
    end
  end
end
