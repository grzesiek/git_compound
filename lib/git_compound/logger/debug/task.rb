module GitCompound
  module Task
    # Debug messages for Task
    #
    class Task
      extend Logger::Debugger

      debug_before(:execute_on) do |directory|
        "Executing task `#{@name}` "                 \
        "defined in manifest `#{@manifest.name}`, "  \
        "in line `#{@block.source_location.last}`, " \
        "with directory arg `#{directory}`"
      end
    end
  end
end
