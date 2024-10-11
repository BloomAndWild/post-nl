# frozen_string_literal: true

require "spec_helper"

RSpec.describe PostNL::HttpClient do
  # Specify valid staging config via ENV vars to record VCR cassettes
  let(:base_url) { ENV["BASE_URL"] || "https://example.com" }
  let(:api_key) { ENV["API_KEY"] || "dummy_api_key" }
  let(:faraday_connection_instance) { instance_double(Faraday::Connection) }

  subject { described_class.instance }

  # Configure the client with the required credentials
  before do
    configure_client(
      base_url: base_url,
      api_key: api_key
    )
  end

  # Prevent instance double from leaking between tests
  after do
    PostNL::HttpClient
      .instance
      .instance_variable_set(:@connection, nil)
  end

  describe "#request" do
    it "raises a NetworkError when a network error occurs" do
      allow(Faraday).to receive(:new).and_return(faraday_connection_instance)
      allow(faraday_connection_instance).to receive(:run_request).and_raise(Faraday::ConnectionFailed.new(StandardError.new("blah!")))

      expect { subject.request(http_method: :get, path: "/") }.to raise_error(PostNL::Errors::NetworkError)
    end
  end
end
