require 'rails_helper'
require 'sidekiq/testing'

describe PlaylistTracksSearch do
  before do
    Sidekiq::Testing.fake!
  end
  let(:radio){ FactoryGirl.create :radio }
  it "searches track titles by query" do
    track_1 = FactoryGirl.create :track, radio: radio, title: "freedrull 10112018"
    track_2 = FactoryGirl.create :track, radio: radio, title: "ducks volume 2"
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_1.tracks << track_1
    playlist_1.tracks << track_2

    result =PlaylistTracksSearch.perform(playlist_1.playlist_tracks, "ducks").map(&:track)
    expect(result).to include(track_2)
    expect(result).to_not include(track_1)
  end
  it "searches track tags" do
    vaporwave_label = radio.labels.create name: "Vaporwave"
    dnb_label = radio.labels.create name: "dnb"
    track_1 = FactoryGirl.create :track, radio: radio, title: "freedrull 10112018"
    track_1.labels << vaporwave_label
    track_2 = FactoryGirl.create :track, radio: radio, title: "ducks volume 2"
    track_2.labels << dnb_label
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_1.tracks << track_1
    playlist_1.tracks << track_2

    result = PlaylistTracksSearch.perform(playlist_1.playlist_tracks, "", ["vaporwave"]).map(&:track)
    expect(result).to include(track_1)
    expect(result).to_not include(track_2)

    result = PlaylistTracksSearch.perform(playlist_1.playlist_tracks, "", ["vaporwave", "dnb"]).map(&:track)
    expect(result).to_not include(track_1)
    expect(result).to_not include(track_2)
  end
  it "searches tracks by query and tags" do
    track_1 = FactoryGirl.create :track, radio: radio, title: "freedrull 10112018"
    track_2 = FactoryGirl.create :track, radio: radio, title: "ducks volume 2"
    track_3 = FactoryGirl.create :track, radio: radio, title: "ducks volume 3"
    vaporwave_label = radio.labels.create name: "Vaporwave"
    dnb_label = radio.labels.create name: "dnb"
    track_1.labels << vaporwave_label
    track_2.labels << dnb_label
    track_3.labels << dnb_label
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_1.tracks << track_1
    playlist_1.tracks << track_2
    playlist_1.tracks << track_3

    result = PlaylistTracksSearch.perform(playlist_1.playlist_tracks, "volume 3", ["dnb"]).map(&:track)
    expect(result).to include(track_3)
    expect(result).to_not include(track_1)
    expect(result).to_not include(track_2)
  end
end
