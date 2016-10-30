require 'jsonapi/client/resource'
require 'jsonapi/client/relationship'
require 'jsonapi/client/link'
require 'jsonapi/client/error'

module JSONAPI
  class Client
    class Document
      attr_reader :data, :included, :errors, :links, :meta

      def initialize(document, link_data = true)
        JSONAPI::Parser::Document.parse!(document)
        parse_data!(document['data'], document['included'])
        link_data! if link_data
        parse_errors!(document['errors'])
        parse_links!(document['links'])
        parse_meta!(document['meta'])
      end

      private

      def parse_data!(data, included)
        return unless data
        @data =
          if data.respond_to?(:each)
            data.map { |h| Resource.new(h) }
          else
            Resource.new(data)
          end
        @included = Array(included).map { |h| Resource.new(h) }
      end

      def index
        return @index unless @index.nil?
        @index = {}
        (Array(@data) + @included).each do |resource|
          resource_identifier = [resource.type, resource.id]
          @index[resource_identifier] = resource
        end

        @index
      end

      def link_data!
        (Array(@data) + @included).each do |resource|
          resource.relationships.each do |_, rel|
            rel.link_data!(index)
          end
        end
      end

      def parse_errors!(errors)
        @errors = Array(errors).map { |h| Error.new(h) }
      end

      def parse_links!(links)
        @links = {}
        (links || {}).map do |key, h|
          @links[key] = Link.new(h)
        end
      end

      def parse_meta!(meta)
        @meta = meta
      end
    end
  end
end
