require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe PlaylistTrack, :type => :model do
  before do
    Sidekiq::Testing.fake!
  end

  it "sets podcast_published_date on save" do
    Timecop.freeze Time.local(1990) do
      now = DateTime.now
      playlist = FactoryBot.create :playlist
      track = FactoryBot.create :track, radio: playlist.radio
      playlist.add_track track
      expect(playlist.playlist_tracks.first.podcast_published_date).to eq(now)
    end
  end

  it "calls persist_playlist_to_redis on save" do
    playlist = FactoryBot.create :playlist
    track = FactoryBot.create :track, radio: playlist.radio
    expect(SavePlaylistToRedisWorker).to receive(:perform_later).with(playlist.id)
    PlaylistTrack.create playlist: playlist, track: track
  end

  it "calls persist_playlist_to_redis after destroy" do
    playlist = FactoryBot.create :playlist
    track = FactoryBot.create :track, radio: playlist.radio
    playlist_track = PlaylistTrack.create playlist: playlist, track: track
    expect(SavePlaylistToRedisWorker).to receive(:perform_later).with(playlist.id)
    playlist_track.destroy
  end
end
