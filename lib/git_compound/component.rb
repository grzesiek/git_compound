module GitCompound
  # Component
  #
  class Component
    attr_reader :name
    attr_accessor :version, :source, :destination

    def initialize(name, parent = nil, &block)
      @name   = name
      @parent = parent
      DSL::ComponentDSL.new(self, &block) if block
      raise CompoundSyntaxError, "No block given for component `#{@name}`" unless block
      raise GitCompoundError, "Component `#{@name}` invalid" unless valid?
    end

    def process(*workers)
      workers.each { |worker| worker.visit_component(self) }
      @manifest.process(*workers) if manifest
    end

    def manifest
      @manifest ||= @source.manifest
    end

    def ancestors
      return [] if @parent.nil? || @parent.component.nil?
      @parent.component.ancestors.dup << @parent.component
    end

    def valid?
      [@version, @source, @destination, @name].all?
    end

    def ==(other)
      tests = [(source.location == other.source.location)]
      tests << (manifest.md5sum == other.manifest.md5sum) if
        manifest && other.manifest
      tests.any?
    end
  end
end
