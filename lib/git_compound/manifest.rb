module GitCompound
  # Manifest class for .gitcompound / Compoundfile
  #
  class Manifest
    extend Dsl::Delegator
    delegate :dsl, [:name, :components, :tasks]

    def initialize(contents)
      @dsl = dsl_eval_contents(contents)
    end

    private

    def dsl_eval_contents(contents)
      Dsl::Manifest.new(contents)
    rescue => e
      raise CompoundSyntaxError, e
    end
  end
end
