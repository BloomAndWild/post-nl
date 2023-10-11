# frozen_string_literal: true

require "spec_helper"

RSpec.describe CarrierName::Config do
  it { is_expected.to respond_to(:base_url, :base_url=) }
  it { is_expected.to respond_to(:username, :username=) }
  it { is_expected.to respond_to(:password, :password=) }
  it { is_expected.to respond_to(:logger, :logger=) }
end
