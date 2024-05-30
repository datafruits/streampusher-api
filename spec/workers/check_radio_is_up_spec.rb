require 'rails_helper'
require 'webmock/rspec'
require 'sidekiq/testing'

describe CheckRadioIsUp do
  before do
    Sidekiq::Testing.inline!
  end
  after do
    Sidekiq::Testing.disable!
  end

  xit "sends alert emails if the radio is down" do
    radio = FactoryBot.create :radio, name: "garf_radio"
    url = radio.icecast_json
    stub_request(:any, url).
      to_return(body: File.read("spec/fixtures/icecast_json.json"))
    CheckRadioIsUp.new.perform
    expect(ActionMailer::Base.deliveries.last.subject).to eq "Radio garf_radio is not reachable"
  end

  xit "doesn't alert emails if the radio is up" do
    radio = FactoryBot.create :radio, name: "datafruits"
    url = radio.icecast_json
    stub_request(:any, url).
      to_return(body: File.read("spec/fixtures/icecast_json.json"))
    CheckRadioIsUp.new.perform
    expect(ActionMailer::Base.deliveries.last.try(:subject)).not_to eq "Radio datafruits is not reachable"
  end
end
