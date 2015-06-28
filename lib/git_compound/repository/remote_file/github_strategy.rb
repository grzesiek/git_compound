require 'net/http'
require 'uri'

module GitCompound
  module Repository
    class RemoteFile
      # Git archive strategy
      #
      class GithubStrategy < RemoteFileStrategy
        GITHUB_URI     = 'https://raw.githubusercontent.com'
        GITHUB_PATTERN = 'git@github.com:\/|https:\/\/github.com\/'

        def initialize(source, ref, file)
          super
          @uri = github_uri
        end

        def contents
          raise FileUnreachableError unless reachable?
          raise FileNotFoundError unless exists?
          @response.body
        end

        def reachable?
          @source.match(/#{GITHUB_PATTERN}/) ? true : false
        end

        def exists?
          @response ||= http_response(@uri)
          @response.code == 200.to_s
        end

        private

        def github_uri
          github_location = @source.sub(/^#{GITHUB_PATTERN}/, '')
          file_uri = "#{GITHUB_URI}/#{github_location}/#{@ref}/#{@file}"
          URI.parse(file_uri)
        end

        def http_response(uri)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.open_timeout = 4
          http.read_timeout = 4
          params = { 'User-Agent' => 'git_compound' }
          req = Net::HTTP::Get.new(uri.request_uri, params)
          http.request(req)
        end
      end
    end
  end
end
