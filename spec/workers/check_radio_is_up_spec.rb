require 'rails_helper'
require 'webmock/rspec'
require 'sidekiq/testing'

describe CheckRadioIsUp do
  before do
    Sidekiq::Testing.inline!
  end
  xit "sends alert emails if the radio is down" do
    radio = FactoryGirl.create :radio
    url = radio.icecast_panel_url
    stub_request(:any, "http://is-this-dongle-working.herokuapp.com/?site=#{url.to_s}").
      to_return(body: "no")
    CheckRadioIsUp.new.perform
    expect(ActionMailer::Base.deliveries.last.subject).to eq "Radio datafruits is not reachable"
  end
end
