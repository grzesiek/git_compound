module GitCompound
  # Task
  #
  class Task
    def initialize(name, type = nil, &block)
      @name = name
      @type = type
      block.call(self) if block
    end
  end
end
