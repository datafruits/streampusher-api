require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Radio, :type => :model do
  before do
    Sidekiq::Testing.fake!
  end
  let(:dj){ FactoryBot.create :user }
  it "knows its default playlist redis key" do
    radio = FactoryBot.create :radio
  end

  it "container name only allows letters, numbers, and underscores" do
    radio = FactoryBot.create :radio, name: "&%^pizza3$ .party!  time"

    expect(radio.container_name).to eq "pizza3partytime"
  end

  it "creates a default playlist" do
    radio = FactoryBot.create :radio
    expect(radio.playlists.first.name).to eq "default"
    expect(radio.default_playlist_id).to eq radio.playlists.first.id
  end

  it "tells you the currently scheduled show" do
    radio = FactoryBot.create :radio
    playlist_1 = FactoryBot.create :playlist, radio: radio
    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio, dj: dj,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am")
    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(radio.current_scheduled_show).to eq scheduled_show_1
    end
  end

  it "tells you the next scheduled show" do
    radio = FactoryBot.create :radio
    playlist_1 = FactoryBot.create :playlist, radio: radio
    PersistPlaylistToRedis.perform playlist_1

    playlist_2 = FactoryBot.create :playlist, name: "my_playlist_2", radio: radio
    PersistPlaylistToRedis.perform playlist_2

    show_series = ShowSeries.create title: "monthly jammer jam", description: "cool", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month

    scheduled_show_1 = FactoryBot.create :scheduled_show, playlist: playlist_1, radio: radio, dj: dj,
      start_at: Chronic.parse("January 1st 2090 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2090 at 01:30 am"),
      show_series_id: show_series.id

    scheduled_show_2 = FactoryBot.create :scheduled_show, playlist: playlist_2, radio: radio, dj: dj,
      start_at: Chronic.parse("January 1st 2092 at 10:30 pm"), end_at: Chronic.parse("January 2nd 2092 at 01:30 am"),
      show_series_id: show_series.id

    Timecop.travel Chronic.parse("January 1st 2090 at 11:30 pm") do
      expect(radio.current_scheduled_show).to eq scheduled_show_1
      expect(radio.next_scheduled_show).to eq scheduled_show_2
    end
  end

  it "gives disk_usage for tracks" do
    radio = FactoryBot.create :radio
    track = FactoryBot.create :track, radio: radio, filesize: 500
    track = FactoryBot.create :track, radio: radio, filesize: 500
    expect(radio.disk_usage).to eq 1000
  end

  it "relay_mp3_url should be without spaces" do
    radio = FactoryBot.create :radio, name: "public radio cool"
    expect(radio.relay_mp3_url).to eq "https://streampusher-relay.club/publicradiocool.mp3"
  end
end
