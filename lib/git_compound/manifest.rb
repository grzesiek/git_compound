module GitCompound
  # Manifest class for .gitcompound / Compoundfile
  #
  class Manifest
    def initialize(contents)
      @contents = contents
      @dsl = dsl_eval_contents(contents)
    end

    # delegators

    def name
      @dsl.instance_variable_get(:@name)
    end

    def components
      @dsl.instance_variable_get(:@components)
    end

    def tasks
      @dsl.instance_variable_get(:@tasks)
    end

    private

    def dsl_eval_contents(contents)
      Dsl.new(contents)
    rescue => e
      raise CompoundSyntaxError, e
    end
  end
end
