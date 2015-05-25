module GitCompound
  # Component
  #
  class Component
    attr_accessor :version, :branch, :sha
    attr_accessor :source, :destination

    def initialize(name, &block)
      @name = name
      if block
        Dsl::ComponentDsl.new(self, &block)
        validate
      end
    end

    def process_dependencies
      @manifest = manifest_load
      @manifest.process_dependencies if @manifest
    end

    def manifest_load
      strategies = [FileContents::GitLocalStrategy]
                  # Contents::GitArchiveStrategy,
                  # Contents::GitHubStrategy]

      ref = lastest_matching_ref
      strategies.each do |strategy|
        begin
          file = strategy.new(@source, ref, 'Compoundfile')
        rescue FileNotFound
          file = strategy.new(@source, ref, '.gitcompound')
        rescue FileUnreachable
          next
        end
        return Manifest.new(file.contents)
      end

      nil
    end

    def refs
      refs = `git ls-remote #{@source}`
      refs.scan(%r{^(\b[0-9a-f]{5,40}\b)\srefs\/(heads|tags)\/(.+)})
    end

    def versions
      version_tags = refs.select do |ref|
        ref[1] == 'tags' &&
        ref[2].start_with?('v') &&
        !ref[2].match(/.*\^\{\}$/) # annotated tag objects
      end
      version_tags.each { |v| v.delete_at(1) }
      Hash[version_tags.map(&:reverse)]
    end

    def branches
      heads = refs.select { |ref| ref[1] == 'heads' }
      Hash[heads.map(&:reverse)]
    end

    private

    def lastest_matching_ref
      validate
    end

    def validate
      case
      when @sha && !@sha.match(/[0-9a-f]{5,40}/)
        raise CompoundSyntaxError,
              'Invalid SHA format'
      when ![@version, @branch, @sha].one?
        raise CompoundSyntaxError,
              'Version, sha and branch cannot be use with each other'
      end
    end
  end
end
