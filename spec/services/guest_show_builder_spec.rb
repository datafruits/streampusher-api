require 'rails_helper'

describe GuestShowBuilder do
  it 'assigns the params for a new guest show' do
    ShowSeries.create! title: "GuestFruits", description: "test", start_time: Time.now, end_time: Time.now + 2.hours
    user = FactoryBot.create :user, fruit_ticket_balance: 500
    params = {:title=>"test test test ",
              :start_date=>"2025-01-31",
              :end_date=>nil,
              :start_time=>"2025-02-01T03:00:20.721Z",
              :end_time=>"Sat, 01 Feb 2025 04:00:20 GMT",
              :description=>"test test test ",
              :recurring_interval=>"not_recurring",
              :recurring_cadence=>nil,
              :recurring_weekday=>nil,
              :status=>nil}
    users_params = {:user_ids=>["2"]}
    labels_params = {}
    episode = GuestShowBuilder.perform user, params, users_params, labels_params
    expect(episode.valid?).to be true
    episode.save!
  end
end
