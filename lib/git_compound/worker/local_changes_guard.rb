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
        return unless component.exists?

        @component  = component
        @repository = component.repository

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
        return unless @repository.untracked_files?(subcomponents_dirs)

        raise LocalChangesError,
              "Component `#{@component.name}` contains untracked files !"
      end

      def subcomponents_dirs
        locked_dirs = @lock.components.map { |locked| "#{locked.path}".chop }
        component_subdirs = locked_dirs.select do |locked_dir|
          locked_dir.start_with?(@component.path)
        end

        component_subdirs.collect do |subdir|
          subdir.sub(/^#{@component.path}/, '').split(File::SEPARATOR).first
        end
      end
    end
  end
end
