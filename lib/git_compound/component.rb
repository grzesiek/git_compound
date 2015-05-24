module GitCompound
  # Component
  #
  class Component
    def initialize(name, &block)
      @name = name
      block.call(self) if block
    end

    def version(ver)
      ver
    end

    def source(src)
      src
    end

    def destination(dest)
      dest
    end

  end
end
