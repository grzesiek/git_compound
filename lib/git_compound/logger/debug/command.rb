module GitCompound
  # Debug cases for Command
  #
  module Command
    extend Logger::Debugger

    debug_before(:run) do |command|
      "GitCompound v#{GitCompound::VERSION}\n" \
      "Running command `#{command}`"
    end
  end
end
