module GitCompound
  module Repository
    class RemoteFile
      # Git archive strategy
      #
      class GitArchiveStrategy < AbstractStrategy
        def initialize(source, ref, file)
          super
          opts = "--format=tar --remote=#{@source} #{@ref} -- #{@file} | tar -O -xf -"
          @command = GitCommand.new(:archive, opts)
          @command.execute!
        end

        def contents
          raise FileUnreachableError unless reachable?
          raise FileNotFoundError unless exists?
          @command.output
        end

        def reachable?
          @command.valid? || @command.output.include?('did not match any files')
        end

        def exists?
          @command.valid?
        end
      end
    end
  end
end
