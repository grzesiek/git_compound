module GitCompound
  # Compound Domain Specific Language
  #
  module Dsl
    def name(component_name)
      @name = component_name.to_sym
    end

    def component(component_name)
      { name: component_name, test: 'asd' }.merge!(@components || {})
    end
  end
end
