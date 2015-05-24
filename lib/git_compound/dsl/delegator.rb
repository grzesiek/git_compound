module GitCompound
  module Dsl
    # Delegator module
    #
    module Delegator
      def delegate(object_name, variables)
        variables.each do |variable|
          define_method(variable) do
            object = instance_variable_get("@#{object_name}")
            object.instance_variable_get("@#{variable}")
          end
        end
      end

      def self.extended(base)
        base.private_class_method :delegate
      end
    end
  end
end
