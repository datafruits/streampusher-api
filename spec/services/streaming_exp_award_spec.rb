require 'rails_helper'

describe StreamingExpAward do
  it 'creates exp point award with correct amount and type' do
    radio = Radio.create name: 'datafruits'
    user = FactoryBot.create :user
    user2 = FactoryBot.create :user, username: "poo", email: "poo@tv.com"
    playlist = Playlist.create radio: radio, name: "big tunes"
    track = FactoryBot.create :track, uploaded_by: user, radio: radio
    show = FactoryBot.create :scheduled_show, start_at: 1.hours.from_now, end_at: 2.hours.from_now, playlist: playlist, dj: user, radio: radio
    show.performers << user2
    StreamingExpAward.perform track, show
    expect(
      ExperiencePointAward.where(award_type: :streamingatron, amount: track.length / 30, user: user).count).to eq 1
    expect(
      ExperiencePointAward.where(award_type: :streamingatron, amount: track.length / 30, user: user2).count).to eq 1
  end
end
