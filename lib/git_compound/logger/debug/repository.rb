module GitCompound
  module Repository
    # Debug messages for GitCommand
    #
    class GitCommand
      extend Logger::Debugger
      debug_before(:execute!) { "Running Git command `#{@command}`" }
    end
  end
end
