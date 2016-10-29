module JSONAPI
  module Client
    class Error
      attr_reader :id, :links, :status, :code, :title, :detail, :source, :meta

      def initialize(error)
        parse_id!(error['id'])
        parse_links!(error['links'])
        parse_status!(error['status'])
        parse_code!(error['code'])
        parse_title!(error['title'])
        parse_detail!(error['detail'])
        parse_source!(error['source'])
        parse_meta!(error['meta'])
      end

      def parse_id!(id)
        @id = id
      end

      def parse_links!(links)
        (links || {}).map do |key, h|
          @links[key] = Link.new(h)
        end
      end

      def parse_status!(status)
        @status = status
      end

      def parse_code!(code)
        @code = code
      end

      def parse_title!(title)
        @title = title
      end

      def parse_detail!(detail)
        @detail = detail
      end

      def parse_source!(source)
        @source = source
      end

      def parse_meta!(meta)
        @meta = meta
      end
    end
  end
end
