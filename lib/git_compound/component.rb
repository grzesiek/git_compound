require 'forwardable'
require 'fileutils'

module GitCompound
  # Component
  #
  class Component < Node
    extend Forwardable
    delegate [:sha, :ref, :origin, :version] => :@source
    delegate [:path, :exists?, :repository] => :@destination

    attr_reader :name
    attr_accessor :source, :destination

    def initialize(name, parent = nil, &block)
      @name   = name
      @parent = parent
      DSL::ComponentDSL.new(self, &block) if block
      raise CompoundSyntaxError, "No block given for component `#{@name}`" unless block
      raise GitCompoundError, "Component `#{@name}` invalid" unless valid?
    end

    def valid?
      [@name, @source, @destination].all?
    end

    def process(*workers)
      workers.each { |worker| worker.visit_component(self) }
      @manifest.process(*workers) if manifest
    end

    def manifest
      @manifest ||= @source.manifest
    end

    def build!
      @source.clone(path)
      @destination.repository do |repo|
        repo.checkout(@source.ref)
      end
    end

    def update!
      @destination.repository do |repo|
        repo.fetch
        repo.checkout(@source.ref)
        repo.merge if repo.branches.include?(@source.ref)
      end
    end

    def remove!
      raise GitCompoundError, 'Risky directory !' if
        path.start_with?('/') || path.include?('..')
      raise GitCompoundError, 'Not a directory !' unless
        File.directory?(path)

      FileUtils.remove_entry_secure(path)
    end

    def ==(other)
      origin == other.origin || manifest == other.manifest
    end

    def to_hash
      { name: @name,
        sha:  @source.sha,
        source: @source.origin,
        destination: @destination.path
      }
    end
  end
end
