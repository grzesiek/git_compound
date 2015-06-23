module GitCompound
  # Component
  #
  class Component < Node
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
      @source.clone
      @destination.checkout
    end

    def conflicts?(*components)
      components.any? do |other_component|
        match_destination =
          (destination.expanded_path == other_component.destination.expanded_path)
        match_identity_and_version =
          (self == other_component && version == other_component.version)

        match_destination && !match_identity_and_version
      end
    end

    def ==(other)
      tests = [(source.location == other.source.location)]
      tests << (manifest == other.manifest) if manifest && other.manifest
      tests.any?
    end
  end
end
