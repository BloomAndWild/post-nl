# frozen_string_literal: true

require "spec_helper"

RSpec.describe PostNL::HttpClient do
  # Specify valid staging config via ENV vars to record VCR cassettes
  let(:base_url) { ENV["BASE_URL"] || "https://example.com" }
  let(:api_key) { ENV["API_KEY"] || "dummy_api_key" }

  # Configure the client with the required credentials
  before do
    configure_client(
      base_url: base_url,
      api_key: api_key
    )
  end

  describe "#request" do
    it "raises a NetworkError when a network error occurs" do
      allow_any_instance_of(Faraday::Connection).to receive(:run_request).and_raise(Faraday::ConnectionFailed)

      expect { described_class.instance.request(http_method: :get, path: "/") }.to raise_error(PostNL::Errors::NetworkError)
    end
  end
end
