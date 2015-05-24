module GitCompound
  # Component
  #
  class Component
    attr_accessor :version, :source, :destination

    def initialize(name, &block)
      @name = name
      @manifest = nil
      if block
        Dsl::ComponentDsl.new(self, &block)
      end
    end
  end
end
