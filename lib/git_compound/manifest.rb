module GitCompound
  # Manifest
  #
  class Manifest
    attr_accessor :name, :components, :tasks
    attr_reader :component

    def initialize(contents, component = nil)
      @contents  = contents
      @component = component
      DSL::ManifestDSL.new(self, contents)
    end

    def process(*workers)
      workers.each { |worker| worker.instance.visit_manifest(self) }
      components.each_value { |component| component.process(*workers) }
    end

    def md5sum
      Digest::MD5.hexdigest(@contents)
    end
  end
end
