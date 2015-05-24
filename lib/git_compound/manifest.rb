module GitCompound
  # Manifest class for .gitcompound / Compoundfile
  #
  class Manifest
    extend Dsl::Delegator
    delegate :dsl, [:name, :components, :tasks]

    def initialize(contents)
      @dsl = Dsl::ManifestDsl.new(contents)
    end

    def process_dependencies
      components.each_value(&:process_dependencies)
    end

    def build
    end
  end
end
