require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Playlist, :type => :model do
  before do
    Sidekiq::Testing.fake!
  end

  it 'adds a track to the playlist' do
    playlist = FactoryBot.create :playlist
    track = FactoryBot.create :track, radio: playlist.radio
    playlist.add_track track
    expect(playlist.tracks.include?(track)).to eq true
  end

  it 'removes a track from a playlist' do
    playlist = FactoryBot.create :playlist
    track = FactoryBot.create :track, radio: playlist.radio
    playlist.add_track track
    playlist.remove_track track
    expect(playlist.tracks.include?(track)).to eq false
  end

  it "reset default to most recently updated playlist if default is destroyed" do
    radio  = FactoryBot.create :radio
    playlist_1 = FactoryBot.create :playlist, radio: radio, updated_at: 2.days.ago
    playlist_2 = FactoryBot.create :playlist, radio: radio, updated_at: 1.day.ago
    radio.default_playlist.destroy
    expect(radio.reload.default_playlist).to eq playlist_2
  end
end
