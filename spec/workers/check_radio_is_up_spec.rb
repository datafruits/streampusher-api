require 'rails_helper'
require 'sidekiq/testing'

describe CheckRadioIsUp do
  before do
    Sidekiq::Testing.inline!
  end
  it "sends alert emails if the radio is down" do
    radio = FactoryGirl.create :radio
    CheckRadioIsUp.perform
    expect(AdminMailer.to_receive(:radio_not_reachable).with(radio))
  end
end
