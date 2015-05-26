module GitCompound
  # Component
  #
  class Component
    attr_accessor :version, :branch, :sha
    attr_accessor :source, :destination

    def initialize(name, &block)
      @name = name
      return unless block
      Dsl::ComponentDsl.new(self, &block)
      validate_refs
      @repository = GitRepository.new(@source)
    end

    def process_dependencies
      @manifest = manifest_load
      @manifest.process_dependencies if @manifest
    end

    def manifest_load
      loader = GitFileLoader.new(@source, lastest_matching_ref)
      contents = loader.contents('Compoundfile', '.gitcompound')
      Manifest.new(contents)
    rescue FileNotFoundError
    end

    def refs
      @repository.refs
    end

    def versions
      version_tags = refs.select do |ref|
        ref[1] == 'tags' &&
        ref[2].start_with?('v') &&
        !ref[2].match(/.*\^\{\}$/) # annotated tag objects
      end
      version_tags.collect! { |v| [v.last[1..-1], v.first] }
      Hash[version_tags]
    end

    def branches
      heads = refs.select { |ref| ref[1] == 'heads' }
      Hash[heads.map(&:reverse)]
    end

    private

    def lastest_matching_ref
      validate_refs
      requirement = Gem::Requirement.new(versions.keys)
      :master
    end

    def validate_refs
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
