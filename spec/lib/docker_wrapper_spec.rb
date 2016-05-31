require_relative '../../lib/docker_wrapper'
require 'rails_helper'

describe DockerWrapper do
  it "creates a new docker container" do
    VCR.use_cassette "create_container" do
      container = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast'
      expect(container.id).to_not eq nil
    end
  end

  it "starts the container with ports exposed" do
    VCR.use_cassette "start container" do
      container = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast'
      container.start
      expect(container.host_port(8000)).to_not eq nil
      container.stop
    end
  end

  it "sets the env" do
    VCR.use_cassette "set_env" do
      container = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast_with_env', ["RADIO_NAME=coolradio"]
      container.start
      expect(container.env.include?("RADIO_NAME=coolradio")).to eq true
    end
  end
end
