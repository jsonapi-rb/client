require 'jsonapi/parser'

require 'jsonapi/client/document'
require 'jsonapi/client/request'
require 'jsonapi/client/response'

module JSONAPI
  class Client
    def initialize(base_url: nil, headers: {})
      @base_url = base_url
      @headers = {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => 'application/vnd.api+json'
      }.merge!(headers)
    end

    def [](endpoint)
      request(@base_url, endpoint)
    end

    def request(base_url, endpoint, headers = {})
      Request.new(base_url, endpoint, @headers.merge(headers))
    end
  end
end
