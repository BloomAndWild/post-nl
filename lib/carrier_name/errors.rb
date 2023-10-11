# frozen_string_literal: true

module CarrierName
  module Errors
    class NetworkError < StandardError; end

    class BaseError < StandardError
      attr_reader :status, :body

      def initialize(status, body)
        @status = status
        @body = body

        super(build_message)
      end
    end

    class ServerError < BaseError
      private

      def build_message
        message = "Server error occurred. Status code: #{status}"
        message += ", Errors: #{body}" if !body.empty?

        message
      end
    end

    class ClientError < BaseError
      private

      def build_message
        message = "Client error occurred. Status code: #{status}"
        message += ", Errors: #{parsed_errors}" if !parsed_errors.empty?

        message
      end

      # Builds a human-readable representation of the errors based on the expected
      # error format.
      # We rescue any parsing errors and return a fallback value as we don't want
      # any new exceptions to be raised from within this method.
      def parsed_errors
        # TODO: Update this method with carrier-specific error parsing

        parsed_body
      rescue StandardError
        body
      end

      def parsed_body
        # TODO: Update this method with carrier-specific error parsing

        body
      end
    end
  end
end
