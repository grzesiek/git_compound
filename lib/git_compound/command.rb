module GitCompound
  # GitCompount command facade
  #
  module Command
    def build(*args)
      execute(Procedure::Build, args)
    end

    def update(*args)
      execute(Procedure::Update, args)
    end

    def check(*args)
      execute(Procedure::Check, args)
    end

    def show(*args)
      execute(Procedure::Show, args)
    end

    def help(*args)
      execute(Procedure::Help, args)
    end

    def execute(procedure, args)
      procedure.new(args).execute!
    end

    def run(command, args)
      abort(Procedure::Help.message) unless methods.include?(command.to_sym)
      public_send(command, *args)
    rescue GitCompoundError => e
      abort "Error: #{e.message}".on_red.white.bold
    end
  end
end
