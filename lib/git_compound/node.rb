module GitCompound
  # Abstract node class
  #
  class Node
    attr_reader :parent

    def process(*workers)
      raise NotImplementedError
    end

    def ancestors
      return [] if @parent.nil? || @parent.parent.nil?
      ancestor = @parent.parent
      ancestor.ancestors.dup << ancestor
    end
  end
end
