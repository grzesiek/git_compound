require 'forwardable'

module GitCompound
  # Component
  #
  class Component < Node
    extend Forwardable

    attr_reader :name
    attr_accessor :version, :source, :destination

    def initialize(name, parent = nil, &block)
      @name   = name
      @parent = parent
      DSL::ComponentDSL.new(self, &block) if block
      raise CompoundSyntaxError, "No block given for component `#{@name}`" unless block
      raise GitCompoundError, "Component `#{@name}` invalid" unless valid?
    end

    def valid?
      [@version, @source, @destination, @name].all?
    end

    def process(*workers)
      workers.each { |worker| worker.visit_component(self) }
      @manifest.process(*workers) if manifest
    end

    def manifest
      @manifest ||= @source.manifest
    end

    def build
      @source.clone(destination_path)
      @destination.repository do |repo|
        repo.checkout(@source.ref)
      end
    end

    def update
      @destination.repository do |repo|
        repo.fetch
        repo.checkout(@source.ref)
      end
    end

    def remove!
      path = destination_path

      raise GitCompoundError, 'Risky directory !' if
        path.start_with?('/') || path.include?('..')

      raise GitCompoundError, 'Not a directory !' unless
        File.directory?(path)

      FileUtils.remove_entry_secure(path)
    end

    # components comparison

    def conflicts?(*components)
      components.any? do |other|
        match_destination?(other) &&
          !match_identity_and_version?(other)
      end
    end

    def match_destination?(other)
      destination_path == other.destination_path
    end

    def match_identity_and_version?(other)
      self == other && version == other.version
    end

    def ==(other)
      origin == other.origin ||
        manifest == other.manifest
    end

    def to_hash
      { name: @name,
        sha:  @source.sha,
        source: @source.origin,
        destination: @destination.expanded_path
      }
    end

    # delegators

    delegate [:sha, :origin, :repository] => :@source
    def_delegator :@destination, :expanded_path, :destination_path
    def_delegator :@destination, :exists?,       :destination_exists?
    def_delegator :@destination, :repository,    :destination_repository
  end
end
