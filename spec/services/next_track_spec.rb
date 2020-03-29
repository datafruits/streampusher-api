require 'rails_helper'
require 'sidekiq/testing'

describe NextTrack do
  before do
    Sidekiq::Testing.fake!
  end

  let(:dj){ FactoryBot.create :user }
  let(:radio){ FactoryBot.create :radio }
  it "tells you what track is supposed to play next with fade and que points" do
    track_1 = FactoryBot.create :track, radio: radio
    track_1.update length: 120
    playlist_1 = FactoryBot.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1

    track_2 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/wau.mp3"
    track_2.update length: 312
    track_3 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/unhappy_supermarket.mp3"
    track_3.update length: 208
    playlist_2 = FactoryBot.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    playlist_2.tracks << track_3
    PersistPlaylistToRedis.perform playlist_2

    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    scheduled_show_2 = FactoryBot.create :scheduled_show, playlist: playlist_2, radio: radio,
      start_at: Chronic.parse("January 1st 2092 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2092 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "0", track: track_1.audio_file_name })
    end

    Timecop.travel Chronic.parse("January 1st 2092 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "0",  track: track_3.audio_file_name })
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "0",  track: track_2.audio_file_name})
    end
  end

  it "supplies fade out points if the next track will overlap with the next scheduled show" do
    track_1 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/datafruits-ovenrake-12-01-2015.mp3"
    track_1.update length: 8221
    playlist_1 = FactoryBot.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1

    track_2 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/wau.mp3"
    track_3 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/unhappy_supermarket.mp3"
    playlist_2 = FactoryBot.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    playlist_2.tracks << track_3
    PersistPlaylistToRedis.perform playlist_2

    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 1st 2090 at 11:30 pm")

    scheduled_show_2 = FactoryBot.create :scheduled_show, playlist: playlist_2, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 11:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 10:30 pm") do
      expect(NextTrack.perform(radio)).to eq({ cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "3599", track: track_1.audio_file_name })
    end
  end

  it "uses the default playlist if there is no scheduled show" do
    track_1 = FactoryBot.create :track, radio: radio
    track_1.update length: 120
    playlist_1 = FactoryBot.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1

    track_2 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/wau.mp3"
    track_2.update length: 312
    playlist_2 = FactoryBot.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    radio.update default_playlist_id: playlist_2.id
    PersistPlaylistToRedis.perform playlist_2

    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2020 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "0", track: track_2.audio_file_name })
    end
  end

  it "supplies fade out points if the next track in the default playlist will overlap with the next scheduled show" do
    track_1 = FactoryBot.create :track, radio: radio
    track_1.update length: 120
    playlist_1 = FactoryBot.create :playlist, radio: radio
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1

    track_2 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/datafruits-ovenrake-12-01-2015.mp3"
    track_2.update length: 8221
    playlist_2 = FactoryBot.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    radio.update default_playlist_id: playlist_2.id
    PersistPlaylistToRedis.perform playlist_2

    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 09:30 pm") do
      expect(NextTrack.perform(radio)).to eq({cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "3599", track: track_2.audio_file_name })
    end
  end

  it "returns an error if no tracks are in the current playlist" do
    playlist_1 = FactoryBot.create :playlist, radio: radio
    PersistPlaylistToRedis.perform playlist_1
    radio.update default_playlist_id: playlist_1.id

    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(NextTrack.perform(radio)).to eq({error: "No tracks!"})
    end
  end

  it "returns an error if no tracks are in the default playlist" do
    playlist_1 = FactoryBot.create :playlist, radio: radio
    radio.update default_playlist_id: playlist_1.id
    PersistPlaylistToRedis.perform playlist_1
    expect(NextTrack.perform(radio)).to eq({ error: "No tracks!" })
  end

  it "doesnt assign cue_out if no_cue_out is set on the playlist" do
    track_1 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/datafruits-ovenrake-12-01-2015.mp3"
    track_1.update length: 8221
    playlist_1 = FactoryBot.create :playlist, radio: radio, no_cue_out: true
    playlist_1.tracks << track_1
    PersistPlaylistToRedis.perform playlist_1

    track_2 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/wau.mp3"
    track_3 = FactoryBot.create :track, radio: radio, audio_file_name: "spec/fixtures/unhappy_supermarket.mp3"
    playlist_2 = FactoryBot.create :playlist, name: "my_playlist_2", radio: radio
    playlist_2.tracks << track_2
    playlist_2.tracks << track_3
    PersistPlaylistToRedis.perform playlist_2

    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 1st 2090 at 11:30 pm")

    scheduled_show_2 = FactoryBot.create :scheduled_show, playlist: playlist_2, radio: radio,
      start_at: Chronic.parse("January 1st 2090 at 11:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")

    Timecop.travel Chronic.parse("January 1st 2090 at 10:30 pm") do
      expect(NextTrack.perform(radio)).to eq({ cue_in: "0", fade_out: "0", fade_in: "0", cue_out: "0", track: track_1.audio_file_name })
    end
  end
end
