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
    rescue FileNotFound
      @manifest = nil
    else
      @manifest.process_dependencies
    end

    def load_manifest
      strategies = [FileContents::LocalFileStrategy]
#                    Contents::GitArchiveStrategy,
#                    Contents::GitHubStrategy]

      strategies.each do |strategy|
        begin
          contents = strategy.new(@source, 'Compoundfile').contents
        rescue FileNotFound
          contents = strategy.new(@source, '.gitcompound').contents
        rescue FileUnreachable
          next
        end
        return Manifest.new(contents)
      end
    end
  end
end
