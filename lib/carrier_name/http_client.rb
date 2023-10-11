# frozen_string_literal: true

require "singleton"
require "faraday"

# A singleton class that:
#   * Provides helper methods for making HTTP requests using Faraday with
#     basic auth
#   * Handles exceptions from the underlying HTTP library and re-raises our
#     custom set of exceptions
module CarrierName
  class HttpClient
    include Singleton

    DEFAULT_HEADERS = {
      content_type: "application/json"
    }.freeze

    def connection
      @connection ||= Faraday.new do |conn|
        conn.adapter Faraday.default_adapter
        conn.response :raise_error # raise exceptions on 4xx, 5xx responses
        conn.headers = DEFAULT_HEADERS
      end
    end

    # General purpose request method for general API requests
    # Returns a Faraday::Response object
    def request(http_method:, path:, payload: nil, token: auth_token)
      headers = {
        "Authorization" => "Basic #{token}",
        "Content-Type" => "application/json"
      }

      connection.run_request(http_method, base_url + path, payload, headers)
    rescue Faraday::ConnectionFailed, Faraday::SSLError, Faraday::TimeoutError => e
      raise Errors::NetworkError.new("Network error occurred: #{e.message}")
    rescue Faraday::ClientError => e
      raise Errors::ClientError.new(e.response[:status], e.response[:body])
    rescue Faraday::ServerError => e
      raise Errors::ServerError.new(e.response[:status], e.response[:body])
    end

    private

    # Generate bearer token from client ID and secret
    def auth_token
      Base64.strict_encode64("#{username}:#{password}")
    end

    def config
      Client.config
    end

    def username
      config.username
    end

    def password
      config.password
    end

    def base_url
      config.base_url
    end
  end
end
