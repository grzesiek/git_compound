require 'yaml'

module GitCompound
  # Class that represents lock file
  #
  class Lock
    FILENAME = '.gitcompound.lock'

    def self.exist?
      super(FILENAME)
    end

    attr_reader :lock

    def initialize(file = FILENAME)
      @file = file
      @lock = YAML.load(File.read(file))
      @lock = {} unless @lock.is_a? Hash
    end

    def lock_component(component)
      @lock[:components].store(component.name, component.to_hash)
    end

    def lock_manifest(manifest)
      @lock[:manifest] = manifest.md5sum
    end

    def write
      File.open(@file, 'w') { |f| f.write @lock.to_yaml }
    end

    def components
      @lock[:components].to_h.map do |name, locked|
        Component.new(name) do
          sha locked[:sha]
          source locked[:source]
          destination locked[:destination]
        end
      end
    end

    def manifest
      @lock[:manifest]
    end
  end
end
