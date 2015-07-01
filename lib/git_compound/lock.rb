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
      @locked = {} unless @locked.is_a? Hash
    end

    def lock_components(components)
      components.each do |component|
        @locked[:components] << component.to_hash
      end
    end

    def lock_manifest(manifest)
      @locked[:manifest] = manifest.md5sum
    end

    def write
      File.open(@file, 'w') { |f| f.puts @locked.to_yaml }
    end

    def contents
      @locked
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

    def manifest
      @locked[:manifest]
    end
  end
end
