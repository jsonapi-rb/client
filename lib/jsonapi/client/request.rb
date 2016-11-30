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

      def call
        response = Net::HTTP.start(uri.host, uri.port,
                                   use_ssl: uri.scheme == 'https') do |http|
          http.request request
        end

        Response.new(response)
      end

      def list
        @method = :get
        @uri = uri
        self
      end

      def list!
        list.call
      end

      def find(id)
        @method = :get
        @uri = uri(id)
        self
      end

      def find!(id)
        find(id).call
      end

      def create(hash)
        hash[:type] ||= @endpoint
        @method = :post
        @uri = uri
        @data = hash
        self
      end

      def create!(hash)
        create(hash).call
      end

      def update(id, hash)
        hash[:type] ||= @endpoint
        @method = :patch
        @uri = uri(id)
        @data = hash
        self
      end

      def update!(id, hash)
        update(id, hash).call
      end

      def delete(id)
        @method = :delete
        @uri = uri(id)
        self
      end

      def delete!(id)
        delete(id).call
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

      def to_hash
        {
          method: @method,
          uri: full_uri,
          base_uri: @uri,
          data: @data,
          params: @params,
          headers: @headers
        }
      end
      alias to_h to_hash

      private

      def request
        uri = URI(full_uri)
        case @method
        when :get
          Net::HTTP::Get.new(uri)
        when :post
          Net::HTTP::Post.new(uri).tap do |req|
            req.body = @data
          end
        when :patch
          Net::HTTP::Patch.new(uri).tap do |req|
            req.body = @data
          end
        when :delete
          Net::HTTP::Delete.new(uri)
        else
          raise "Unknown request method: #{@method}"
        end
      end

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
