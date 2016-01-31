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

  it "calls persist_playlist_to_redis on save" do
    playlist = FactoryGirl.create :playlist
    track = FactoryGirl.create :track, radio: playlist.radio
    expect(SavePlaylistToRedisWorker).to receive(:perform_later).with(playlist.id)
    PlaylistTrack.create playlist: playlist, track: track
  end

  it "calls persist_playlist_to_redis after destroy" do
    playlist = FactoryGirl.create :playlist
    track = FactoryGirl.create :track, radio: playlist.radio
    playlist_track = PlaylistTrack.create playlist: playlist, track: track
    expect(SavePlaylistToRedisWorker).to receive(:perform_later).with(playlist.id)
    playlist_track.destroy
  end
end
