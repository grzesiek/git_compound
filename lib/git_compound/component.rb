module GitCompound
  # Component
  #
  class Component
    attr_reader :name
    attr_accessor :version, :sha, :branch
    attr_accessor :source, :destination

    def initialize(name, &block)
      @name = name
      Dsl::ComponentDsl.new(self, &block) if block
      raise CompoundSyntaxError, "No block given for component `#{@name}`" unless block
      raise GitCompoundError, "Component `#{@name}` invalid" unless valid?
    end

    def process_dependencies
      @manifest.process_dependencies if manifest
    end

    def manifest
      @manifest ||= load_manifest
    end

    def valid?
      [[@version, @branch, @sha].any?,
       @source, @destination, @name].all?
    end

    def lastest_matching_sha
      return @sha if @sha # TODO: verify if SHA exists
      return branch_sha if @branch
      return version_sha if @version
    end

    private

    def load_manifest
      valid_manifests = ['Compoundfile', '.gitcompound']
      contents = @source.repository.first_found_file_contents(valid_manifests,
                                                              lastest_matching_sha)
      Manifest.new(contents)
    rescue FileNotFoundError
      nil
    end

    def branch_sha
      repository_branch_sha = @source.repository.branches[@branch]
      raise DependencyError,
            "Branch #{@branch} not available in #{@source} " \
            "for component `#{@name}`" unless repository_bransh_sha
      repository_branch_sha
    end

    def version_sha
      repository_version_sha = @version.lastest_matching_sha
      raise DependencyError, 'No maching version available for ' \
                             "`#{@name}` component" unless repository_version_sha
      repository_version_sha
    end
  end
end
