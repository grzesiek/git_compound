module GitCompound
  module Command
    module Procedure
      module Element
        # Manifest mixin
        #
        module Manifest
          def initialize(opts)
            super
            @manifest = manifest_load(opts[:manifest])
          end

          def self.included(parent_class)
            parent_class.class_eval do
              include Element::Option
              add_argument :manifest, type: :string, scope: :global
            end
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
