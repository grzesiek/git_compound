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
        Hash[heads.map(&:reverse)]
      end

      def refs
        refs = GitCommand.new('ls-remote', @source).execute
        refs.scan(%r{^(\b[0-9a-f]{5,40}\b)\srefs\/(heads|tags)\/(.+)})
      rescue GitCommandError
        raise RepositoryUnrechableError, 'Could not reach repository'
      end

      def ref_exists?(ref)
        matching = refs.select do |refs_array|
          refs_array.include?(ref.to_s)
        end
        matching.any?
      end

      def file_contents(file, ref)
        loader = GitFileLoader.new(@source, ref)
        loader.contents(file)
      end

      def first_available_file_contents(files, ref)
        contents = nil
        files.each do |file|
          begin
            contents = file_contents(file, ref)
          rescue FileNotFoundError
            next
          end
        end
        contents
      end

      def file_exists?(_file, _ref)
        raise NotImplementedError
      end
    end
  end
end
