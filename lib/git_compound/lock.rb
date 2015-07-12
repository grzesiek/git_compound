require 'yaml'

module GitCompound
  # Class that represents lock file
  #
  class Lock
    FILENAME = '.gitcompound.lock'

    def self.exist?
      File.exist?(FILENAME)
    end

    def initialize(file = FILENAME)
      @file   = file
      @locked = YAML.load(File.read(file)) if self.class.exist?
      @locked = { manifest: '', components: [] } unless @locked.is_a? Hash
    end

    def lock_manifest(manifest)
      @locked[:manifest] = manifest.md5sum
    end

    def lock_component(component)
      @locked[:components] << component.to_hash
    end

    def manifest
      @locked[:manifest]
    end

    def components
      @locked[:components].to_a.map do |locked|
        Component.new(locked[:name].to_sym) do
          sha locked[:sha]
          source locked[:source]
          destination locked[:destination]
        end
      end
    end

    def contents
      @locked
    end

    def find(component)
      components.find do |locked_component|
        locked_component.match_destination?(component)
      end
    end

    def process(worker)
      components.each { |component| worker.visit_component(component) }
    end

    def write
      File.open(@file, 'w') { |f| f.puts @locked.to_yaml }
    end
  end
end
