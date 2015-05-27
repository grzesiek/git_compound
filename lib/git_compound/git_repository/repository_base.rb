module GitCompound
  module GitRepository
    # Git repository base class
    #
    class RepositoryBase
      def initialize(source)
        @source = source
      end

      def versions
        version_tags = refs.select do |ref|
          ref[1] == 'tags' &&
          ref[2].start_with?('v') &&
          !ref[2].match(/.*\^\{\}$/) # annotated tag objects
        end
        version_tags.collect! { |v| [v.last[1..-1], v.first] }
        Hash[version_tags]
      end

      def branches
        heads = refs.select { |ref| ref[1] == 'heads' }
        heads.collect! { |h| [h.last.to_sym, h.first] }
        Hash[heads]
      end

      def refs
        refs = GitCommand.new('ls-remote', @source).execute
        refs.scan(%r{^(\b[0-9a-f]{5,40}\b)\srefs\/(heads|tags)\/(.+)})
      rescue GitCommandError => e
        raise RepositoryUnreachableError, "Could not reach repository: #{e.message}"
      end

      def ref_exists?(ref)
        matching = refs.select do |refs_array|
          refs_array.include?(ref.to_s)
        end
        matching.any?
      end

      def first_file_contents(files, ref)
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

      def file_contents(file, ref)
        raise NotImplementedError
      end

      def file_exists?(_file, _ref)
        raise NotImplementedError
      end
    end
  end
end
