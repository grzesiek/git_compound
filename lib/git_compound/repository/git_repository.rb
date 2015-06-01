module GitCompound
  module Repository
    # Git repository base class
    #
    class GitRepository
      def initialize(source)
        @source = source
      end

      def versions
        version_tags = tags.select do |tag, _|
          tag.match(/^v?#{Gem::Version::VERSION_PATTERN}$/) &&
          !tag.match(/.*\^\{\}$/) # annotated tag objects
        end
        Hash[version_tags.map { |k, v| [k.sub(/^v/, ''), v] }]
      end

      def refs
        refs = GitCommand.new('ls-remote', @source).execute
        refs.scan(%r{^(\b[0-9a-f]{5,40}\b)\srefs\/(heads|tags)\/(.+)})
      rescue GitCommandError => e
        raise RepositoryUnreachableError, "Could not reach repository: #{e.message}"
      end

      def branches
        select_refs('heads')
      end

      def tags
        select_refs('tags')
      end

      def ref_exists?(ref)
        matching = refs.select do |refs_array|
          refs_array.include?(ref.to_s)
        end
        matching.any?
      end

      def first_found_file_contents(files, ref)
        files.each do |file|
          begin
            return file_contents(file, ref)
          rescue FileNotFoundError
            next
          end
        end
        raise FileNotFoundError,
              "Couldn't find any of #{files} files"
      end

      def file_contents(_file, _ref)
        raise NotImplementedError
      end

      def file_exists?(_file, _ref)
        raise NotImplementedError
      end

      private

      def select_refs(name)
        selected_refs = refs.select { |ref| ref[1] == name }
        selected_refs.collect! { |r| [r.last, r.first] }
        Hash[selected_refs]
      end
    end
  end
end
