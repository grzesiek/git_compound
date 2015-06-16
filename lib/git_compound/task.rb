module GitCompound
  # Task
  #
  class Task
    def initialize(name, type = nil, parent = nil, &block)
      @name   = name
      @type   = type
      @parent = parent
      block.call(self) if block
    end
  end
end
