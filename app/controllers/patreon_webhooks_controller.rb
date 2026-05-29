class PatreonWebhooksController < ApplicationController
  def create
    # TODO veryify these headers
    # X-Patreon-Event: [trigger]
    # X-Patreon-Signature: [message signature]
    puts params.inspect
    PatreonWebhookHandler.perform params["data"]
  end
end
