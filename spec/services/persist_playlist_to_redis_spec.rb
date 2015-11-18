require 'rails_helper'

describe PersistPlaylistToRedis do
  it "saves playlists to a redis list" do
    playlist = FactoryGirl.create :playlist
    playlist.tracks << FactoryGirl.create_list(:track, 10, radio: playlist.radio)
    PersistPlaylistToRedis.perform playlist
    redis = Redis.current
    expect(redis.llen("datafruits:playlist:my_playlist")).to eq 10
    expect(redis.lrange("datafruits:playlist:my_playlist", 0, 9)).to eq ["the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3"]
  end

  it "saves interpolated playlists" do
    playlist = FactoryGirl.create :playlist
    playlist.tracks << FactoryGirl.create_list(:track, 10, radio: playlist.radio)
    jingles = FactoryGirl.create :playlist, name: "jingles", radio: playlist.radio
    jingles.tracks = FactoryGirl.create_list(:track, 10, radio: playlist.radio, audio_file_name: "spec/fixtures/wau.mp3")
    playlist.update interpolated_playlist_id: jingles.id,
      interpolated_playlist_track_play_count: 1,
      interpolated_playlist_track_interval_count: 1,
      interpolated_playlist_enabled: true
    PersistPlaylistToRedis.perform playlist
    redis = Redis.current
    expect(redis.llen("datafruits:playlist:my_playlist")).to eq 20
    expect(redis.lrange("datafruits:playlist:my_playlist", 0, 19)).to eq ["the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3", "the_cowbell.mp3", "wau.mp3"]
  end
end
