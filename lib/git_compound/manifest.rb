module GitCompound
  # Manifest clas for .gitcompound / Compoundfile
  #
  class Manifest
    include Dsl

    def self.load!(file)
      manifest = new
      manifest.evaluate(file)
    end

    def evaluate(file, contents = nil)
      instance_contents = (contents || contents_from_file(file))
      eval_contents(file, instance_contents)
      self
    end

    private

    def contents_from_file(file)
      File.read(file)
    rescue => e
      raise CompoundLoadError, e
    end

    def eval_contents(file, contents)
      instance_eval(contents, file.to_s)
    rescue => e
      raise CompoundSyntaxError, e
    end
  end
end
