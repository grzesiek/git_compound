module GitCompound
  # Manifest clas for .gitcompound / Compoundfile
  #
  class Manifest
    def self.load!(file)
      manifest = new
      manifest.evaluate(file)
    end

    def evaluate(file, contents = nil)
      @contents = (contents || contents_from_file(file))
      eval_contents(file, @contents)
    end

    private

    def contents_from_file(file)
      File.read(file)
    rescue => e
      raise CompoundLoadError, e
    end

    def eval_contents(file, contents)
      instance_eval(contents, file)
    rescue => e
      raise CompoundSyntaxError, e
    end
  end
end
