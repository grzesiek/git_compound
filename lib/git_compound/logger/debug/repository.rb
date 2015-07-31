module GitCompound
  module Repository
    # Debug messages for GitCommand
    #
    class GitCommand
      extend Logger::Debugger
      debug_before(:execute!) do
        "Running Git command `#{@command}`" +
          (@workdir ? " in `#{@workdir.split(File::SEPARATOR).last}`" : '')
      end
    end
  end
end
