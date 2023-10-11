# frozen_string_literal: true

require "logger"

def configure_client(base_url: nil, username: nil, password: nil)
  CarrierName::Client.configure do |config|
    config.base_url = base_url || ENV.fetch("BASE_URL")
    config.username = username || ENV.fetch("USERNAME", "")
    config.password = password || ENV.fetch("PASSWORD", "")

    config.logger = Logger.new(STDERR)
    config.logger.level = :debug
  end
end
