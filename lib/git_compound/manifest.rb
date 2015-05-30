module GitCompound
  # Manifest class for .gitcompound / Compoundfile
  #
  class Manifest
    attr_accessor :name, :components, :tasks

    def initialize(contents)
      Dsl::ManifestDsl.new(self, contents)
    end

    def process_dependencies
      components.each_value(&:process_dependencies)
    end

    def build
    end
  end
end
