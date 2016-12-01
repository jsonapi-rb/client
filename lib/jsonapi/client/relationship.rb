module JSONAPI
  class Client
    class Relationship
      attr_reader :data, :links, :meta

      def initialize(relationship)
        parse_data!(relationship['data'])
        parse_links!(relationship['links'])
        parse_meta!(relationship['meta'])
      end

      # @api private
      def link_data!(index)
        if @data.is_a?(Array)
          @data.map! do |ri|
            ri = [ri['type'], ri['id']]
            index[ri]
          end
        elsif !@data.nil?
          ri = [@data['type'], @data['id']]
          @data = index[ri]
        end
      end

      private

      def parse_data!(data)
        @data = data
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
