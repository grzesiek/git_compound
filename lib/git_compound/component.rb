module GitCompound
  # Component
  #
  class Component
    attr_reader :name
    attr_accessor :version, :source, :destination

    def initialize(name, &block)
      @name = name
      DSL::ComponentDSL.new(self, &block) if block
      raise CompoundSyntaxError, "No block given for component `#{@name}`" unless block
      raise GitCompoundError, "Component `#{@name}` invalid" unless valid?
    end

    def process(*workers)
      @manifest.process(*workers) if manifest
    end

    def manifest
      @manifest ||= @source.manifest
    end

    def valid?
      [@version, @source, @destination, @name].all?
    end
  end
end
