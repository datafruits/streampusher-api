require 'rails_helper'
require 'sidekiq/testing'

describe PersistPlaylistToRedis do
  before do
    Sidekiq::Testing.fake!
  end

  it "saves playlists to a redis list" do
    playlist = FactoryGirl.create :playlist
    playlist.tracks << FactoryGirl.create_list(:track, 10, radio: playlist.radio)
    PersistPlaylistToRedis.perform playlist
    redis = Redis.current
    expect(redis.llen("datafruits:playlist:my_playlist")).to eq 10
    ids = redis.lrange("datafruits:playlist:my_playlist", 0, 9)
    tracks = Track.find ids
    expect(tracks.map(&:file_basename)).to eq ["the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3"]
  end

  it "saves interpolated playlists" do
    playlist = FactoryGirl.create :playlist
    track_1 = FactoryGirl.create(:track, radio: playlist.radio)
    playlist.tracks << track_1
    jingles = FactoryGirl.create :playlist, name: "jingles", radio: playlist.radio
    track_2 = FactoryGirl.create(:track, radio: playlist.radio, audio_file_name: "spec/fixtures/wau.mp3")
    jingles.tracks << track_2
    playlist.update interpolated_playlist_id: jingles.id,
      interpolated_playlist_track_play_count: 1,
      interpolated_playlist_track_interval_count: 1,
      interpolated_playlist_enabled: true
    PersistPlaylistToRedis.perform playlist
    redis = Redis.current
    expect(redis.llen("datafruits:playlist:my_playlist")).to eq 2
    expected_array = [track_1.id.to_s,
                      track_2.id.to_s]
    expect(redis.lrange("datafruits:playlist:my_playlist", 0, 19)).to eq expected_array
  end
end
