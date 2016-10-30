require 'jsonapi/client/document'

module JSONAPI
  class Client
    class Response
      def initialize(http_res)
        @http_res = http_res
      end

      def status
        @http_res.code
      end

      def headers
        @http_res.to_hash
      end

      def body
        return nil if body.nil?
        json = JSON.parse(@http_res.body)
        Document.new(json)
      end
    end
  end
end
