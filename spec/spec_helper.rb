# frozen_string_literal: true
require "dotenv"
require "vcr"

require "bundler/setup"
require "post_nl"
require_relative "support/helpers/client_helper"

Dotenv.load

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost                        = true
  c.cassette_library_dir                    = "spec/support/fixtures/vcr_cassettes"
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options                = { match_requests_on: [:uri] }
  # Filtering Basic auth credentials from VCR interaction.
  # TODO: Update this to match the authentication method for the carrier.
  c.filter_sensitive_data("<API_KEY>") do |interaction|
    interaction.request.headers["Apikey"].first
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Allow us to specify VCR cassette via the test definition
  # e.g.:
  #  `it "works", vcr_cassette: "working_request" do ...`
  config.around(:each, :vcr_cassette) do |example|
    name = example.metadata[:vcr_cassette]

    VCR.use_cassette(name) { example.run }
  end
end
