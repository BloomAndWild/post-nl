# frozen_string_literal: true

require "spec_helper"

RSpec.describe CarrierName::Errors do
  describe CarrierName::Errors::NetworkError do
    it "inherits from StandardError" do
      expect(described_class).to be < StandardError
    end
  end

  describe CarrierName::Errors::ServerError do
    it "builds a custom message based on status and body" do
      error = described_class.new(500, "Internal Server Error")

      expect(error.message).to eq("Server error occurred. Status code: 500, Errors: Internal Server Error")
    end
  end

  describe CarrierName::Errors::ClientError do
    it "builds a custom message based on status and body" do
      error = described_class.new(400, "Bad Request")

      expect(error.message).to eq("Client error occurred. Status code: 400, Errors: Bad Request")
    end

    it "rescues any parsing errors and returns the raw body" do
      allow_any_instance_of(described_class).to receive(:parsed_body).and_raise(StandardError)

      error = described_class.new(400, "Bad Request")

      expect(error.message).to eq("Client error occurred. Status code: 400, Errors: Bad Request")
    end
  end
end
