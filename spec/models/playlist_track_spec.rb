require 'rails_helper'

RSpec.describe PlaylistTrack, :type => :model do
  it "sets podcast_published_date on save" do
    Timecop.freeze Time.local(1990) do
      now = DateTime.now
      playlist = FactoryGirl.create :playlist
      track = FactoryGirl.create :track, radio: playlist.radio
      playlist.add_track track
      expect(playlist.playlist_tracks.first.podcast_published_date).to eq(now)
    end
  end
end
