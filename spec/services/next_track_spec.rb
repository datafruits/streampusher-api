require 'rails_helper'
require 'sidekiq/testing'

describe NextTrack do
  before do
    Sidekiq::Testing.fake!
  end

  let(:dj){ FactoryGirl.create :user }
  let(:radio){ FactoryGirl.create :radio }
  it "tells you what track is supposed to play next with fade and que points" do
    track_1 = FactoryGirl.create :track, radio: radio
    track_1.update length: 120
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1
    show_1 = FactoryGirl.create :show, playlist: playlist_1, dj: dj, radio: radio

    track_2 = FactoryGirl.create :track, radio: radio, audio_file_name: "spec/fixtures/wau.mp3"
    track_2.update length: 312
    track_3 = FactoryGirl.create :track, radio: radio, audio_file_name: "spec/fixtures/unhappy_supermarket.mp3"
    track_3.update length: 208
    playlist_2 = FactoryGirl.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    playlist_2.tracks << track_3
    PersistPlaylistToRedis.perform playlist_2
    show_2 = FactoryGirl.create :show, playlist: playlist_2, dj: dj, radio: radio

    scheduled_show_1 = FactoryGirl.create :scheduled_show, show: show_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    scheduled_show_2 = FactoryGirl.create :scheduled_show, show: show_2, radio: radio,
      start_at: Chronic.parse("January 1st 2092 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2092 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "120", track: track_1.file_basename })
    end

    Timecop.travel Chronic.parse("January 1st 2092 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "208",  track: track_3.file_basename })
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "312",  track: track_2.file_basename })
    end
  end

  it "supplies fade out points if the next track will overlap with the next scheduled show" do
    track_1 = FactoryGirl.create :track, radio: radio, audio_file_name: "spec/fixtures/datafruits-ovenrake-12-01-2015.mp3"
    track_1.update length: 8221
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1
    show_1 = FactoryGirl.create :show, playlist: playlist_1, dj: dj, radio: radio

    track_2 = FactoryGirl.create :track, radio: radio, audio_file_name: "spec/fixtures/wau.mp3"
    track_3 = FactoryGirl.create :track, radio: radio, audio_file_name: "spec/fixtures/unhappy_supermarket.mp3"
    playlist_2 = FactoryGirl.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    playlist_2.tracks << track_3
    PersistPlaylistToRedis.perform playlist_2
    show_2 = FactoryGirl.create :show, playlist: playlist_2, dj: dj, radio: radio

    scheduled_show_1 = FactoryGirl.create :scheduled_show, show: show_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 1st 2090 at 11:30 pm")

    scheduled_show_2 = FactoryGirl.create :scheduled_show, show: show_2, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 11:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 10:30 pm") do
      expect(NextTrack.perform(radio)).to eq({ cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "3599", track: track_1.file_basename })
    end
  end

  it "uses the default playlist if there is no scheduled show" do
    track_1 = FactoryGirl.create :track, radio: radio
    track_1.update length: 120
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1
    show_1 = FactoryGirl.create :show, playlist: playlist_1, dj: dj, radio: radio

    track_2 = FactoryGirl.create :track, radio: radio, audio_file_name: "spec/fixtures/wau.mp3"
    track_2.update length: 312
    playlist_2 = FactoryGirl.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    PersistPlaylistToRedis.perform playlist_2
    radio.update default_playlist_id: playlist_2.id

    scheduled_show_1 = FactoryGirl.create :scheduled_show, show: show_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 1995 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "312", track: track_2.file_basename })
    end
  end

  it "supplies fade out points if the next track in the default playlist will overlap with the next scheduled show" do
    track_1 = FactoryGirl.create :track, radio: radio
    track_1.update length: 120
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1
    show_1 = FactoryGirl.create :show, playlist: playlist_1, dj: dj, radio: radio

    track_2 = FactoryGirl.create :track, radio: radio, audio_file_name: "spec/fixtures/datafruits-ovenrake-12-01-2015.mp3"
    track_2.update length: 8221
    playlist_2 = FactoryGirl.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    PersistPlaylistToRedis.perform playlist_2
    radio.update default_playlist_id: playlist_2.id

    scheduled_show_1 = FactoryGirl.create :scheduled_show, show: show_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 09:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "3599", track: track_2.file_basename })
    end
  end

  it "returns an error if no tracks are in the current playlist" do
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    PersistPlaylistToRedis.perform playlist_1
    show_1 = FactoryGirl.create :show, playlist: playlist_1, dj: dj, radio: radio
    radio.update default_playlist_id: playlist_1.id

    scheduled_show_1 = FactoryGirl.create :scheduled_show, show: show_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({error: "No tracks!"})
    end
  end

  it "returns an error if no tracks are in the default playlist" do
    playlist_1 = FactoryGirl.create :playlist, radio: radio
    PersistPlaylistToRedis.perform playlist_1
    show_1 = FactoryGirl.create :show, playlist: playlist_1, dj: dj, radio: radio
    radio.update default_playlist_id: playlist_1.id
    expect(NextTrack.perform(radio)).to eq({ error: "No tracks!" })
  end
end
