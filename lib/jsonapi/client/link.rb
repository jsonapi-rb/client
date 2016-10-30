module JSONAPI
  class Client
    class Link
      attr_reader :href, :meta

      def initialize(relationship)
        if relationship.is_a?(String)
          parse_href!(relationship)
        else
          parse_href!(relationship['href'])
          parse_meta!(relationship['meta'])
        end
      end

      private

      def parse_href!(href)
        @href = href
      end

      def parse_meta!(meta)
        @meta = meta
      end
    end
  end
end
