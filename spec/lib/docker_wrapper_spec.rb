require_relative '../../lib/docker_wrapper'
require 'spec_helper'
require 'vcr'

def test_docker_uri
  scheme = "#{URI(ENV['DOCKER_HOST']).scheme}"
  scheme = "https" if scheme == "tcp"
  host = URI(ENV['DOCKER_HOST']).host
  port = URI(ENV['DOCKER_HOST']).port
  uri = "#{scheme}://#{URI(ENV['DOCKER_HOST']).host}"
  uri << ":#{port}" unless port == 80
  uri
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb

  config.define_cassette_placeholder("<DOCKER_HOST>") do
    test_docker_uri
  end
end

describe DockerWrapper do
  before do
    puts test_docker_uri
  end

  it "creates a new docker container" do
    VCR.use_cassette "create_container" do
      container = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast'
      expect(container.id).to_not eq nil
    end
  end

  it "sets the env" do
    VCR.use_cassette "set_env" do
      container = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast_with_env', ["RADIO_NAME=coolradio"]
      container.start
      expect(container.env.include?("RADIO_NAME=coolradio")).to eq true
    end
  end

  it "sets links" do
    VCR.use_cassette "set_links" do
      container1 = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast1', []
      container1 = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast2', []
      container_with_links = DockerWrapper.find_or_create 'mcfiredrill/icecast', 'coolradio_icecast_with_links', [], ["coolradio_icecast1:icecast1", "coolradio_icecast2:icecast2"]

      expect(container_with_links.links.include?("/coolradio_icecast1:/coolradio_icecast_with_links/icecast1")).to eq true
      expect(container_with_links.links.include?("/coolradio_icecast2:/coolradio_icecast_with_links/icecast2")).to eq true
    end
  end
end
