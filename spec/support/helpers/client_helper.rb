# frozen_string_literal: true

require "logger"

def configure_client(base_url: nil, api_key: nil)
  PostNL::Client.configure do |config|
    config.base_url = base_url || ENV.fetch("BASE_URL")
    config.api_key = api_key || ENV.fetch("API_KEY", "")

    config.logger = Logger.new(STDERR)
    config.logger.level = :debug
  end
end
