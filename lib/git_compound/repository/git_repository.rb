module GitCompound
  module Repository
    # Git repository base class
    #
    class GitRepository
      def initialize(source)
        @source = source
      end

      def clone(destination, options = nil, source = @source)
        args = "#{source} #{destination}"
        args.prepend(options + ' ') if options
        GitCommand.new(:clone, args).execute
      end

      def versions
        git_versions = tags.map { |tag, sha| GitVersion.new(tag, sha) }
        git_versions.select(&:valid?)
      end

      def refs
        refs = GitCommand.new('ls-remote', @source).execute
        refs.scan(%r{^(\b[0-9a-f]{5,40}\b)\srefs\/(heads|tags)\/(.+)})
      rescue GitCommandError => e
        raise RepositoryUnreachableError, "Could not reach repository: #{e.message}"
      end

      def branches
        refs_select('heads')
      end

      def tags
        all = refs_select('tags')
        annotated = all.select { |tag, _| tag =~ /\^\{\}$/ }
        annotated.each_pair do |annotated_tag, annotated_tag_sha|
          tag = annotated_tag.sub(/\^\{\}$/, '')
          all.delete(annotated_tag)
          all[tag] = annotated_tag_sha
        end
        all
      end

      def ref_exists?(ref)
        matching = refs.select do |refs_array|
          refs_array.include?(ref.to_s)
        end
        matching.any?
      end

      # Returns contents of first file found
      #
      def files_contents(files, ref)
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

      def refs_select(name)
        selected_refs = refs.select { |ref| ref[1] == name }
        selected_refs.collect! { |r| [r.last, r.first] }
        Hash[selected_refs]
      end
    end
  end
end
