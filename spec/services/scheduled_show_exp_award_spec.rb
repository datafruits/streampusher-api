require 'rails_helper'

describe ScheduledShowExpAward do
  it "awards xp when show is scheduled" do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user
    playlist = FactoryBot.create :playlist, radio: radio
    track = FactoryBot.build :track
    track.save
    track.update uploaded_by: user
    playlist.tracks << track
    scheduled_show = FactoryBot.create :scheduled_show, playlist: playlist, dj: user, start_at: 2.days.from_now, end_at: 2.days.from_now + 2.hours, radio: radio

    ScheduledShowExpAward.perform scheduled_show
    expected_xp = playlist.tracks.first.length / 60
    expect(user.experience_points).to eq expected_xp
  end
end
