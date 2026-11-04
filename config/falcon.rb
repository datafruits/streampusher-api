#!/usr/bin/env falcon-host
# frozen_string_literal: true

require "falcon/environment/rack"

service_name = ENV.fetch("FALCON_SERVICE_NAME", "streampusher")
bind_address = ENV.fetch("FALCON_BIND", "http://127.0.0.1:3000")
worker_count = Integer(ENV.fetch("FALCON_COUNT", "2"))
application_root = File.expand_path("..", __dir__)

service service_name, root: application_root do
  include Falcon::Environment::Rack

  count worker_count

  endpoint do
    # TLS and HTTP/2 terminate at Nginx. The private upstream connection uses
    # HTTP/1.1, which supports streaming responses without requiring h2c.
    Async::HTTP::Endpoint.parse(bind_address)
  end
end
