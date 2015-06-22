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

    def ==(other)
      tests = [(source.location == other.source.location)]
      tests << (manifest == other.manifest) if manifest && other.manifest
      tests.any?
    end
  end
end
