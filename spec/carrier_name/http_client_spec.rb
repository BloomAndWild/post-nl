# frozen_string_literal: true

require "spec_helper"

RSpec.describe CarrierName::HttpClient do
  # Specify valid staging config via ENV vars to record VCR cassettes
  let(:base_url) { ENV["BASE_URL"] || "https://example.com" }
  let(:username) { ENV["USERNAME"] || "dummy_username" }
  let(:password) { ENV["PASSWORD"] || "dummy_password" }

  # Configure the client with the required credentials
  before do
    configure_client(
      base_url: base_url,
      username: username,
      password: password
    )
  end

  describe "#request" do
    it "raises a NetworkError when a network error occurs" do
      allow_any_instance_of(Faraday::Connection).to receive(:run_request).and_raise(Faraday::ConnectionFailed)

      expect { described_class.instance.request(http_method: :get, path: "/") }.to raise_error(CarrierName::Errors::NetworkError)
    end
  end
end
