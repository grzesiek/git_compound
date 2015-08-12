module GitCompound
  module Command
    module Procedure
      module Element
        # Manifest mixin
        #
        module Manifest
          def initialize(args)
            filename = args.find { |arg| arg.is_a? String }
            @manifest = manifest_load(filename)
            super
          end

          private

          def manifest_load(filename)
            files = filename ? [filename] : GitCompound::Manifest::FILENAMES
            found = files.select { |file| File.exist?(file) }

            raise GitCompoundError,
                  "Manifest `#{filename || files.inspect}` not found !" if found.empty?

            contents = File.read(found.first)
            GitCompound::Manifest.new(contents)
          end
        end
      end
    end
  end
end
