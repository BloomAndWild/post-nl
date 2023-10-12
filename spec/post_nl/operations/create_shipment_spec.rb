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

  describe "#execute" do
    describe "successful requests", vcr_cassette: "create_shipment_request_confirm_true" do
      it "returns a hash" do
        expect(subject.execute).to be_a(Hash)
      end

      it "returns the ResponseShipments key" do
        expect(subject.execute).to have_key(:ResponseShipments)
      end

      it "returns the Barcode (tracking number) key" do
        response = subject.execute

        expect(response.dig(:ResponseShipments, 0)).to have_key(:Barcode)
      end

      it "returns the Labels > Content key" do
        response = subject.execute

        expect(response.dig(:ResponseShipments, 0, :Labels, 0)).to have_key(:Content)
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

    describe "error handling" do
      context "when there is a client error" do
        let(:payload) { { broken: "json" } }
        let(:expected_message_pattern) do
          Regexp.new(
            "^Client error occurred. Status code: 400.*" \
            "The user is not authorized for this operation based on the provided CustomerCode"
          )
        end

        it "raises a PostNL::Errors::ClientError", vcr_cassette: "create_shipment_request_client_error" do
          expect { subject.execute }.to raise_error(
            PostNL::Errors::ClientError,
            expected_message_pattern
          )
        end
      end
    end
  end
end
