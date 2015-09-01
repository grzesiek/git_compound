module GitCompound
  module Command
    module Procedure
      # Build command class
      #
      class Build < Procedure
        include Element::Lock
        include Element::Option
        include Element::Subprocedure

        add_subprocedure :build_lock,     BuildLock
        add_subprocedure :build_manifest, BuildManifest

        step :build_dispatcher do
          if locked?
            subprocedure(:build_lock)
          else
            subprocedure(:build_manifest)
          end
        end
      end
    end
  end
end
