# frozen_string_literal: true

require "spec_helper"

RSpec.describe PostNL::Operations::CreateShipment, :aggregate_failures do
  subject { described_class.new(payload: payload) }

  let(:payload) { JSON.parse(File.read("spec/support/fixtures/create_shipment_request.json")) }

  # Specify valid staging config via ENV vars to record VCR cassettes
  let(:base_url) { "https://api-sandbox.postnl.nl" }
  let(:api_key) { ENV["API_KEY"] || "dummy_api_key" }
  let(:http_client) { PostNL::HttpClient.instance }

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

    describe "label confirmation" do
      before do
        allow(http_client).to receive(:request).and_call_original
      end

      context "when confirm is not specified" do
        subject do
          described_class.new(
            http_client: http_client,
            payload: payload
          )
        end

        it "includes ?confirm=true in the endpoint URL by default" do
          subject.execute

          expect(http_client).to have_received(:request).with(
            http_method: :post,
            path: "/shipment/v2_2/label?confirm=true",
            payload: payload.to_json
          )
        end
      end

      context "with confirm: true option" do
        subject do
          described_class.new(
            http_client: http_client,
            payload: payload,
            confirm: true
          )
        end

        it "includes ?confirm=true in the endpoint URL" do
          subject.execute

          expect(http_client).to have_received(:request).with(
            http_method: :post,
            path: "/shipment/v2_2/label?confirm=true",
            payload: payload.to_json
          )
        end
      end

      context "with confirm: false option", vcr_cassette: "create_shipment_request_confirm_false" do
        subject do
          described_class.new(
            http_client: http_client,
            payload: payload,
            confirm: false
          )
        end

        it "includes ?confirm=false in the requested endpoint path" do
          subject.execute

          expect(http_client).to have_received(:request).with(
            http_method: :post,
            path: "/shipment/v2_2/label?confirm=false",
            payload: payload.to_json
          )
        end
      end
    end
  end
end
