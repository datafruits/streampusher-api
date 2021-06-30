require 'patreon'

class SyncPatreons
  def self.perform
    # client_id = ENV['PATREON_CLIENT_ID']
    # client_secret = ENV['PATREON_CLIENT_SECRET']
    # refresh_token = ENV['PATREON_REFRESH_TOKEN']
    # redirect_uri = ENV['PATREON_REDIRECT_URI']
    #
    # oauth_client = Patreon::OAuth.new(client_id, client_secret)
    # tokens = oauth_client.refresh_token(refresh_token, redirect_uri)
    # puts tokens
    # access_token = tokens['access_token']
    access_token = '2FRdFfQpYGiEXpFt3CL0guzYLSkPqok9udTx2_6N7T8'

    # Fetching basic data
    api_client = Patreon::API.new(access_token)

    campaign_response = api_client.fetch_campaign()
    campaign_id = campaign_response.data[0].id

    # Fetching all pledges
    all_pledges = []
    cursor = nil
    while true do
      page_response = api_client.fetch_page_of_pledges(campaign_id, { :count => 25, :cursor => cursor })
      all_pledges += page_response.data
      next_page_link = page_response.links[page_response.data]['next']
      if next_page_link
        parsed_query = CGI::parse(next_page_link)
        cursor = parsed_query['page[cursor]'][0]
      else
        break
      end
    end

    # Mapping to all patrons. Feel free to customize as needed.
    # As with all standard Ruby objects, (pledge.methods - Object.methods) will list the available attributes and relationships
    # puts all_pledges.map{ |pledge|
    #   pledge.inspect
    #   # return {
    #   #   full_name: pledge.patron.full_name,
    #   #   amount_cents: pledge.amount_cents
    #   # }
    # }
    all_pledges.each do |pledge|
      full_name = pledge.patron.full_name
      amount_cents = pledge.amount_cents
      patreon_id = pledge.patron.id

      patreon = Patreon.find_or_create_by full_name: full_name
      patreon.amount_cents = amount_cents
      patreon.patreon_id = patreon_id
      patreon.save!
    end
  end
end
