module GitCompound
  module Worker
    # Worker that defends local changes in
    # component repositories
    #
    class LocalChangesGuard < Worker
      def initialize(lock)
        @lock = lock
      end

      def visit_component(component)
        @component  = component
        @repository = component.destination_repository

        check_uncommited_changes!
        check_untracked_files!
      end

      private

      def check_uncommited_changes!
        return unless @repository.uncommited_changes?

        raise LocalChangesError,
              "Component `#{@component.name}` contains uncommited changes !"
      end

      def check_untracked_files!
        locked_dirs = @lock.components.map { |locked| "#{locked.destination_path}".chop }
        component_subdirs = locked_dirs.select do |locked_dir|
          locked_dir.start_with?(@component.destination_path)
        end

        excluded_component_dirs = component_subdirs.collect do |subdir|
          subdir.sub(/^#{@component.destination_path}/, '').split(File::SEPARATOR).first
        end

        return unless @repository.untracked_files?(excluded_component_dirs)

        raise LocalChangesError,
              "Component `#{@component.name}` contains untracked files !"
      end
    end
  end
end
