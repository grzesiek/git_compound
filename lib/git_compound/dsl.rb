module GitCompound
  # Compound Domain Specific Language
  #
  module Dsl
    def initialize
      @name         = ''
      @components   = {}
      @tasks        = {}
    end

    def name(component_name)
      @name = component_name.to_sym
    end

    private

    def component(name, &block)
      @components.store(name.to_sym, Component.new(name, &block))
    end

    def task(name, &block)
      @tasks.store(name.to_sym, Task.new(name, &block))
    end
  end
end
