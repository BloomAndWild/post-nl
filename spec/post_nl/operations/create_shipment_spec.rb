# frozen_string_literal: true

require "spec_helper"

RSpec.describe PostNL::Operations::CreateShipment, :aggregate_failures do
  subject { described_class.new(payload: payload) }

  let(:payload) { JSON.parse(File.read("spec/support/fixtures/create_shipment_request.json")) }

  # Specify valid staging config via ENV vars to record VCR cassettes
  let(:base_url) { "https://api-sandbox.postnl.nl" }
  let(:api_key) { ENV["API_KEY"] || "dummy_api_key" }

  # Configure the client with the required credentials
  before do
    configure_client(
      base_url: base_url,
      api_key: api_key
    )
  end

  describe "#execute", vcr_cassette: "create_shipment_request_confirm_true" do
    it "returns a hash" do
      expect(subject.execute).to be_a(Hash)
    end

    it "returns the ResponseShipments key" do
      expect(subject.execute).to have_key(:ResponseShipments)
    end
  end

  describe "when confirm is not specified" do
    it "includes ?confirm=true in the endpoint URL by default" do
      expect(subject.send(:endpoint)).to include("?confirm=true")
    end
  end

  describe "with confirm: true option" do
    subject do
      described_class.new(payload: payload, confirm: true)
    end

    it "includes ?confirm=true in the endpoint URL" do
      expect(subject.send(:endpoint)).to include("?confirm=true")
    end
  end

  describe "with confirm: false option", vcr_cassette: "create_shipment_request_confirm_false" do
    subject do
      described_class.new(payload: payload, confirm: false)
    end

    it "does not include ?confirm=true in the endpoint URL" do
      expect(subject.send(:endpoint)).to include("?confirm=false")
    end
  end
end
