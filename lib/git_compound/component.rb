module GitCompound
  # Component
  #
  class Component
    attr_accessor :version, :branch, :sha
    attr_accessor :source, :destination, :repository

    def initialize(name, &block)
      @name = name
      return unless block
      Dsl::ComponentDsl.new(self, &block)
      @repository = GitRepository.factory(@source)
    end

    def process_dependencies
      @manifest ||= load_manifest
      @manifest.process_dependencies if @manifest
    end

    def manifest
      @manifest ||= load_manifest
    end

    private

    def load_manifest(*files)
      repository = GitRepository::RepositoryBase.new(@source)
      valid_manifests = ['Compoundfile', '.gitcompound']
      contents = repository.first_available_file_contents(valid_manifests, lastest_matching_ref)
      contents ? Manifest.new(contents) : nil
    end

    def lastest_matching_ref
      return @sha || @branch if [@sha, @branch].any?
      # requirement = Gem::Requirement.new(versions.keys)
      :master
    end
  end
end
