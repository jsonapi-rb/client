require 'net/http'
require 'uri'

require 'jsonapi/include_directive'

module JSONAPI
  class Client
    class Request
      METHOD_CLASS = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        patch: Net::HTTP::Patch,
        delete: Net::HTTP::Delete
      }.freeze

      def initialize(base_url, endpoint, headers)
        @base_url = base_url
        @endpoint = endpoint
        @params = []
        @headers = headers
      end

      def list
        request(:get, uri)
      end

      def request(method, uri, data = {})
        uri = URI(uri)
        req = METHOD_CLASS[method].new(uri, @headers)
        req.body = data if data

        http_res = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end

        Response.new(http_res)
      end

      def find(id)
        request(:get, uri(id))
      end

      def create(hash)
        hash[:type] ||= @endpoint
        request(:post, uri, hash)
      end

      def update(id, hash)
        hash[:type] ||= @endpoint
        request(:patch, uri(id), hash)
      end

      def delete(id)
        request(:delete, uri(id))
      end

      def headers(hash)
        @params.merge!(hash)
        self
      end

      def params(hash)
        @params <<
          if hash.is_a?(String)
            hash
          elsif hash.is_a?(Hash)
            hash.map { |k, v| "#{k}=#{v}" }
          end
        self
      end

      def include(hash)
        include = JSONAPI::IncludeDirective.new(hash).to_string
        @params << "include=#{include}"
        self
      end

      def fields(hash)
        hash = { @endpoint => hash } if hash.is_a?(Array)
        @params += hash.map { |k, v| "fields[#{k}]=#{v.join(',')}" }
        self
      end

      private

      def uri(id = nil)
        uri = "#{@base_url}/#{@endpoint}"
        uri += "/#{id}" if id
        uri += "?#{@params.join('&')}" if @params.any?

        uri
      end
    end
  end
end
