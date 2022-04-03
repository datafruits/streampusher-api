require 'rails_helper'
require 'sidekiq/testing'

describe PersistPlaylistToRedis do
  include RedisConnection

  before do
    Sidekiq::Testing.fake!
  end

  it "saves playlists to a redis list" do
    playlist = FactoryBot.create :playlist
    playlist.tracks << FactoryBot.create_list(:track, 10, radio: playlist.radio)
    PersistPlaylistToRedis.perform playlist
    expect(redis.llen("datafruits:playlist:my_playlist")).to eq 10
    ids = redis.lrange("datafruits:playlist:my_playlist", 0, 9)
    tracks = Track.find ids
    expect(tracks.map(&:file_basename)).to eq ["the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3", "the_cowbell.mp3"]
  end

  it "saves interpolated playlists" do
    playlist = FactoryBot.create :playlist
    track_1 = FactoryBot.create(:track, radio: playlist.radio)
    6.times { playlist.tracks << track_1 }
    jingles = FactoryBot.create :playlist, name: "jingles", radio: playlist.radio
    track_2 = FactoryBot.create(:track, radio: playlist.radio, audio_file_name: "spec/fixtures/wau.mp3")
    jingles.tracks << track_2
    # every 3 tracks play 1 track from the jingles playlist
    playlist.update interpolated_playlist_id: jingles.id,
      interpolated_playlist_track_play_count: 1,
      interpolated_playlist_track_interval_count: 3,
      interpolated_playlist_enabled: true
    PersistPlaylistToRedis.perform playlist
    expect(redis.llen("datafruits:playlist:my_playlist")).to eq 8
    expected_array = [track_1.id.to_s,
                      track_2.id.to_s,
                      track_1.id.to_s,
                      track_1.id.to_s,
                      track_1.id.to_s,
                      track_2.id.to_s,
                      track_1.id.to_s,
                      track_1.id.to_s]
    expect(redis.lrange("datafruits:playlist:my_playlist", 0, 7)).to eq expected_array
  end

  it "shuffles playlist when shuffle option is set" do
    playlist = FactoryBot.create :playlist, shuffle: true
    playlist.tracks << FactoryBot.create_list(:track, 10, radio: playlist.radio)
    PersistPlaylistToRedis.perform playlist
  end
end
