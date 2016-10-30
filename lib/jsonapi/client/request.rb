require 'net/http'
require 'uri'

require 'jsonapi/include_directive'

module JSONAPI
  class Client
    class Request
      def initialize(base_url, endpoint = nil)
        @base_url = base_url
        @endpoint = endpoint
        @params = {}
        @headers = {}
      end

      def list
        @method = :get
        @uri = uri
        self
      end

      def find(id)
        @method = :get
        @uri = uri(id)
        self
      end

      def create(hash)
        hash[:type] ||= @endpoint
        @method = :post
        @uri = uri
        @data = hash
        self
      end

      def update(id, hash)
        hash[:type] ||= @endpoint
        @method = :patch
        @uri = uri(id)
        @data = hash
        self
      end

      def delete(id)
        @method = :delete
        @uri = uri(id)
        self
      end

      def include(hash)
        include = JSONAPI::IncludeDirective.new(hash).to_string
        @params[:include] = include
        self
      end

      def fields(hash)
        hash = { @endpoint => hash } if hash.is_a?(Array)
        hash.each do |k, v|
          @params["fields[#{k}]".to_sym] = v.join(',')
        end
        self
      end

      def params(hash)
        @params.merge!(hash)
        self
      end

      def headers(hash)
        @headers.merge!(hash)
        self
      end

      def to_h
        {
          method: @method,
          uri: full_uri,
          base_uri: @uri,
          data: @data,
          params: @params,
          headers: @headers
        }
      end

      private

      def query
        @params.map { |k, v| "#{k}=#{v}" }.join('&')
      end

      def uri(id = nil)
        uri = @base_url
        uri += "/#{@endpoint}" unless @endpoint.nil?
        uri += "/#{id}" if id

        uri
      end

      def full_uri
        full_uri = @uri
        query.tap do |q|
          full_uri += "?#{q}" unless q.empty?
        end

        full_uri
      end
    end
  end
end
