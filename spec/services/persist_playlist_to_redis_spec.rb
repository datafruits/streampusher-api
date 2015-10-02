require 'rails_helper'

describe PersistPlaylistToRedis do
  it "saves interpolated playlists" do
    playlist = FactoryGirl.create :playlist
    playlist.tracks << FactoryGirl.create_list(:tracks)
    jingles = FactoryGirl.create :playlist, name: "jingles"
    PersistPlaylistToRedis.perform playlist
    redis = Redis.current
  end
end
