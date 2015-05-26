module GitCompound
  # Component
  #
  class Component
    attr_accessor :version, :branch, :sha
    attr_accessor :source, :destination
    attr_accessor :repository

    def initialize(name, &block)
      @name = name
      return unless block
      Dsl::ComponentDsl.new(self, &block)
      @repository = GitRepository.factory(@source)
    end

    def process_dependencies
      manifest.process_dependencies if @manifest
    end

    def manifest
      contents = load_manifest_contents('Compoundfile', '.gitcompound')
      contents ? Manifest.new(contents) : nil
    end

    def versions
      version_tags = @repository.refs.select do |ref|
        ref[1] == 'tags' &&
        ref[2].start_with?('v') &&
        !ref[2].match(/.*\^\{\}$/) # annotated tag objects
      end
      version_tags.collect! { |v| [v.last[1..-1], v.first] }
      Hash[version_tags]
    end

    def branches
      heads = @repository.refs.select { |ref| ref[1] == 'heads' }
      Hash[heads.map(&:reverse)]
    end

    private

    def load_manifest_contents(*files)
      repository = GitRepository::RepositoryBase.new(@source)
      ref = lastest_matching_ref
      contents = nil
      files.each do |file|
        begin
          contents = repository.file_contents(file, ref)
        rescue FileNotFoundError
          next
        end
      end
      contents
    end

    def lastest_matching_ref
      # requirement = Gem::Requirement.new(versions.keys)
      :master
    end
  end
end
