require 'digest'

module GitCompound
  # Manifest
  #
  class Manifest < Node
    attr_accessor :name, :components, :tasks

    def initialize(contents, parent = nil)
      @contents = contents
      @parent   = parent
      DSL::ManifestDSL.new(self, contents)
    end

    def process(*workers)
      workers.each { |worker| worker.visit_manifest(self) }
      components.each_value { |component| component.process(*workers) }
      workers.each { |worker| tasks.each { |task| worker.visit_manifest(task) } }
    end

    def ==(other)
      md5sum == other.md5sum
    end

    def md5sum
      Digest::MD5.hexdigest(@contents)
    end
  end
end
