module GitCompound
  # Task
  #
  class Task
    def initialize(name, &block)
      @name = name
      instance_eval(&block)
    end
  end
end
