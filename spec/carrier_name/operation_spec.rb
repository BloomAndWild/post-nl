# frozen_string_literal: true

require "spec_helper"

RSpec.describe CarrierName::Operation do
  subject { dummy_class.new }

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

  let(:dummy_class) do
    Class.new(described_class) do
      def http_method
        :get
      end

      def endpoint
        "/example_endpoint"
      end
    end
  end

  describe ".execute" do
    it "fails", vcr_cassette: "broken_request" do
      expect { subject.execute }.to raise_error(CarrierName::Errors::ClientError)
    end
  end
end
