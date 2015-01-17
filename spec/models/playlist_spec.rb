require 'rails_helper'

RSpec.describe Playlist, :type => :model do
  it 'adds a track to the playlist' do
    playlist = Playlist.create radio_id: 1
    track = Track.create radio_id: 1
    playlist.add_track track
    expect(playlist.tracks.include?(track)).to eq true
  end

  it 'removes a track from a playlist' do
    playlist = Playlist.create radio_id: 1
    track = Track.create radio_id: 1
    playlist.add_track track
    playlist.remove_track track
    expect(playlist.tracks.include?(track)).to eq false
  end
end
