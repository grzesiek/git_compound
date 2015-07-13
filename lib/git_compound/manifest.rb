require 'digest'

module GitCompound
  # Manifest
  #
  class Manifest < Node
    attr_accessor :name, :components, :tasks

    FILENAMES = %w(Compoundfile .gitcompound)

    def initialize(contents, parent = nil)
      @contents   = contents
      @parent     = parent
      @name       = ''
      @components = {}
      @tasks      = {}
      DSL::ManifestDSL.new(self, contents) if contents
    end

    def process(*workers)
      workers.each { |worker| worker.visit_manifest(self) }
      components.each_value { |component| component.process(*workers) }
      tasks.each_value { |task| workers.each { |worker| worker.visit_task(task) } }
    end

    def ==(other)
      return false unless other.instance_of? Manifest
      md5sum == other.md5sum
    end

    def exists?
      @contents ? true : false
    end

    def md5sum
      Digest::MD5.hexdigest(@contents) if exists?
    end
  end
end
