module JSONAPI
  class Client
    class Resource
      attr_reader :id, :type, :attributes, :relationships, :links, :meta

      def initialize(resource)
        @id = resource['id']
        @type = resource['type']
        parse_attributes!(resource['attributes'])
        parse_relationships!(resource['relationships'])
        parse_links!(resource['links'])
        parse_meta!(resource['meta'])
      end

      private

      def parse_attributes!(attributes)
        @attributes = attributes || {}
      end

      def parse_relationships!(relationships)
        @relationships = {}
        (relationships || {}).map do |key, h|
          @relationships[key] = Relationship.new(h)
        end
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
