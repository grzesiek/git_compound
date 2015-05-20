module GitCompound
  # Component
  #
  class Component
    def initialize(name, &block)
      @name = name
      instance_eval(&block)
    end

    private

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
