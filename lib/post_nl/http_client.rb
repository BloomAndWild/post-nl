# frozen_string_literal: true

require "singleton"
require "faraday"

# A singleton class that:
#   * Provides helper methods for making HTTP requests using Faraday with
#     basic auth
#   * Handles exceptions from the underlying HTTP library and re-raises our
#     custom set of exceptions
module PostNL
  class HttpClient
    include Singleton

    def connection
      @connection ||= Faraday.new do |conn|
        conn.adapter Faraday.default_adapter
        conn.response :raise_error # raise exceptions on 4xx, 5xx responses
      end
    end

    # General purpose request method for general API requests
    # Returns a Faraday::Response object
    def request(http_method:, path:, payload: nil)
      connection.run_request(http_method, base_url + path, payload, headers)
    rescue Faraday::ConnectionFailed, Faraday::SSLError, Faraday::TimeoutError => e
      raise Errors::NetworkError.new("Network error occurred: #{e.message}")
    rescue Faraday::ClientError => e
      raise Errors::ClientError.new(e.response[:status], e.response[:body])
    rescue Faraday::ServerError => e
      raise Errors::ServerError.new(e.response[:status], e.response[:body])
    end

    private

    def headers
      {
        "apikey" => api_key,
        "Content-Type" => "application/json"
      }
    end

    def config
      Client.config
    end

    def api_key
      config.api_key
    end

    def base_url
      config.base_url
    end
  end
end
