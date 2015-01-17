require_relative '../../lib/docker_wrapper'
require 'spec_helper'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end

describe DockerWrapper do
  it "creates a new docker container" do
    VCR.use_cassette "create_container" do
      container = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast'
      expect(container.id).to_not eq nil
    end
  end
  it "uses existing container if it exists" do
    VCR.use_cassette "create_existing_container" do
      container1 = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast'
      container2 = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast'
      expect(container1.id).to eq container2.id
    end
  end
  it "sets the env" do
    VCR.use_cassette "set_env" do
      container = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast2'
      container.start "RADIO_NAME"=>'coolradio'
      expect(container.env.include?("RADIO_NAME=coolradio")).to eq true
    end
  end
end
