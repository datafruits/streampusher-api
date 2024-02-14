require 'rails_helper'

RSpec.describe Shrimpo, type: :model do
  it 'sets end_at from duration' do
    dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj
    shrimpo.save!
    expect(shrimpo.end_at).to eq shrimpo.start_at + 2.hours
    expect(shrimpo.duration).to eq "about 2 hours"
  end

  # it 'sets voting_end_at when changed to voting status' do
  #   dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
  #   shrimpo = Shrimpo.new start_at: Time.now, duration: "2 hours", title: "Shrimp Champions", rule_pack: "dont use pokemon samples", user: dj
  #   shrimpo.save!
  # end
end
