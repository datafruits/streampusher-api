require 'rails_helper'

describe PatreonWebhookHandler do
  it 'saves the pledge to the db and sends a notification' do
    data = {"attributes"=> {"access_expires_at"=>nil, "campaign_currency"=>"USD", "campaign_lifetime_support_cents"=>12345, "campaign_pledge_amount_cents"=>50, "full_name"=>"Anthony Allen Miller", "is_follower"=>false, "is_free_member"=>nil, "is_free_trial"=>nil, "last_charge_date"=>"2014-04-01T00:00:00.000+00:00", "last_charge_status"=>"Paid", "lifetime_support_cents"=>12345, "patron_status"=>"active_patron", "pledge_amount_cents"=>50, "pledge_relationship_start"=>"2014-03-14T00:00:00.000+00:00"} , "id"=>nil, "relationships"=>{"address"=>{"data"=>{"id"=>"826453", "type"=>"address"}, "links"=>{"related"=>"https://www.patreon.com/api/addresses/826453"}}, "campaign"=>{"data"=>{"id"=>"205222", "type"=>"campaign"}, "links"=>{"related"=>"https://www.patreon.com/api/campaigns/205222"}}, "user"=>{"data"=>{"id"=>"1018897", "type"=>"user"}, "links"=>{"related"=>"https://www.patreon.com/api/user/1018897"}}}, "type"=>"member"}
    PatreonWebhookHandler.perform data
    expect(Notification.count).to eq 1
    expect(Notification.last.notification_type).to eq "patreon_sub"
  end
end
