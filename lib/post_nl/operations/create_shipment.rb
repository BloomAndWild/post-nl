# frozen_string_literal: true

module PostNL
  module Operations
    class CreateShipment < Operation
      # TODO: Handle setting optional `?confirm=true` query param
      # E.g. via optional flag in the provided options hash

      BASE_ENDPOINT = "/shipment/v2_2/label"

      def initialize(**options)
        @options = options
        @options[:confirm] = true if @options[:confirm].nil?

        super(**@options)
      end

      private

      def endpoint
        "#{BASE_ENDPOINT}#{query_param}"
      end

      def query_param
        options[:confirm] ? "?confirm=true" : "?confirm=false"
      end

      def http_method
        :post
      end
    end
  end
end
