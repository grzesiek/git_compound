module GitCompound
  module Worker
    # Worker that defends local changes in
    # component repositories
    #
    class LocalChangesGuard < Worker
      def visit_component(component)
        @component  = component
        @repository = component.destination_repository

        check_uncommited_changes!
        check_untracked_files!
        check_unpushed_commits!
      end

      private

      def check_uncommited_changes!
        return unless @repository.uncommited_changes?

        raise LocalChangesError,
              "Component `#{@component.name}` contains uncommited changes !"
      end

      def check_untracked_files!
        return unless @repository.untracked_files?

        raise LocalChangesError,
              "Component `#{@component.name}` contains untracked files !"
      end

      def check_unpushed_commits!
        return unless @repository.unpushed_commits?

        raise LocalChangesError,
              "Component `#{@component.name}` contains unpushed commits !"
      end
    end
  end
end
