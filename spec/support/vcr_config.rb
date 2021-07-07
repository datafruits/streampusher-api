require 'vcr'

def test_docker_uri
  if ENV['DOCKER_HOST']
    scheme = "#{URI(ENV['DOCKER_HOST']).scheme}"
    scheme = "https" if scheme == "tcp"
    host = URI(ENV['DOCKER_HOST']).host
    port = URI(ENV['DOCKER_HOST']).port
    uri = "#{scheme}://#{URI(ENV['DOCKER_HOST']).host}"
    uri << ":#{port}" unless port == 80
    uri
  else
    "http://unix"
  end
end

VCR.configure do |config|
  # config.ignore_localhost = true
  config.ignore_hosts '127.0.0.1', 54660
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb

  config.define_cassette_placeholder("<DOCKER_HOST>") do
    test_docker_uri
  end

  config.define_cassette_placeholder("<STRIPE_KEY>") do
    ENV['STRIPE_KEY']
  end

  config.filter_sensitive_data("<S3_KEY>") do
    ENV.fetch 'S3_KEY', "x"*40
  end

  config.filter_sensitive_data("<S3_SECRET>") do
    ENV.fetch 'S3_SECRET', "x"*40
  end

  config.filter_sensitive_data("<MIXCLOUD_TOKEN>") do
    ENV.fetch "MIXCLOUD_TOKEN", "x"*40
  end

  config.register_request_matcher :s3_uri_matcher do |request1, request2|
    uri1 = URI(request1.uri)
    uri1.query = nil
    uri2 = URI(request2.uri)
    uri2.query = nil
    uri1.to_s.gsub(/\/\d{3}/,"") == uri2.to_s.gsub(/\/\d{3}/,"")
  end

  config.register_request_matcher :s3_image_matcher do |request1, request2|
    uri1 = URI(request1.uri)
    uri2 = URI(request2.uri)

    uri_regex = /^\/artworks\/(original|thumb)\/_hey-hey-[0-9]{8}__[A-z0-9]{64}\.png/
  
    uri1.host == uri2.host && uri_regex.match?(uri1.path) && uri_regex.match?(uri2.path)
  end
end
