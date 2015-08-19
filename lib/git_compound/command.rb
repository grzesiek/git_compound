module GitCompound
  # GitCompount command facade
  #
  module Command
    def build(manifest, opts = {})
      run(Procedure::Build, opts.merge(manifest: manifest))
    end

    def update(manifest, opts = {})
      run(Procedure::Update, opts.merge(manifest: manifest))
    end

    def check(manifest, opts = {})
      run(Procedure::Check, opts.merge(manifest: manifest))
    end

    def show(manifest, opts = {})
      run(Procedure::Show, opts.merge(manifest: manifest))
    end

    def help(opts = {})
      run(Procedure::Help, opts)
    end

    def run(procedure, opts)
      procedure.new(opts).execute!
    rescue GitCompoundError => e
      abort "Error: #{e.message}".on_red.white.bold
    end
  end
end
