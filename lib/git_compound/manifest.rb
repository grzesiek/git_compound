module GitCompound
  # Manifest
  #
  class Manifest
    attr_accessor :name, :components, :tasks

    def initialize(contents)
      DSL::ManifestDSL.new(self, contents)
    end

    def process(*workers)
      workers.each { |worker| worker.instance.visit_manifest(self) }
      components.each_value { |component| component.process(*workers) }
    end
  end
end
