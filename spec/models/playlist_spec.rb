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

  it "sets another playlist to default if default is being destroyed" do
    radio  = FactoryBot.create :radio
    playlist_1 = FactoryBot.create :playlist, radio: radio
    playlist_2 = FactoryBot.create :playlist, radio: radio
    radio.default_playlist.destroy
    radio.reload
    expect(radio.default_playlist.radio_id).to eq playlist_2.radio_id
  end
end
