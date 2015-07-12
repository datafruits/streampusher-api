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
