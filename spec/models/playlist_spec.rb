require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Playlist, :type => :model do
  before do
    Sidekiq::Testing.fake!
  end

  it 'adds a track to the playlist' do
    playlist = FactoryGirl.create :playlist
    track = FactoryGirl.create :track, radio: playlist.radio
    playlist.add_track track
    expect(playlist.tracks.include?(track)).to eq true
  end

  it 'removes a track from a playlist' do
    playlist = FactoryGirl.create :playlist
    track = FactoryGirl.create :track, radio: playlist.radio
    playlist.add_track track
    playlist.remove_track track
    expect(playlist.tracks.include?(track)).to eq false
  end

  it "sets another playlist to default if default is being destroyed" do
    radio  = FactoryGirl.create :radio
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_2 = FactoryGirl.create :playlist, radio: radio
    radio.default_playlist.destroy
    radio.reload
    expect(radio.default_playlist).to eq playlist_2
  end
end
