module GitCompound
  # Component
  #
  class Component
    attr_accessor :version, :source, :destination
    attr_accessor :manifest

    def initialize(name, &block)
      @name = name
      Dsl::ComponentDsl.new(self, &block) if block
    end

    def process_dependencies
      @manifest = load_manifest
      @manifest.process_dependencies if @manifest
    end

    def load_manifest
      strategies = [FileContents::GitLocalStrategy]
                    # Contents::GitArchiveStrategy,
                    # Contents::GitHubStrategy]

      strategies.each do |strategy|
        begin
          file = strategy.new(@source, 'Compoundfile')
        rescue FileNotFound
          file = strategy.new(@source, '.gitcompound')
        rescue FileUnreachable
          next
        end
        return Manifest.new(file.contents)
      end

      nil
    end

    def versions

    end
  end
end
