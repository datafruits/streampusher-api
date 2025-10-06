require 'rails_helper'
require 'sidekiq/testing'

describe ProcessRecording do
  before do
    Sidekiq::Testing.inline!
    @radio = Radio.create name: 'datafruits'
    @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    @playlist = Playlist.create radio: @radio, name: "big tunes"
    @start_at = Chronic.parse("tomorrow at 1:15 pm").utc
    @end_at = Chronic.parse("tomorrow at 3:15 pm").utc
    @date = Date.today.strftime("%m%d%Y")
  end
  after do
    Sidekiq::Testing.disable!
  end
  it 'processes a recording' do
    user = FactoryBot.create :user, username: "emadj"
    recording = FactoryBot.create :recording, radio: @radio
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s, :preserve_exact_body_bytes => true) do
      ProcessRecording.new.perform recording
    end
    track = Track.first

    expect(Track.count).to eq 1
    expect(File.basename(track.audio_file_name)).to eq File.basename(recording.path)
    expect(track.uploaded_by).to eq user
  end

  it 'assigns track to scheduled show' do
    user = FactoryBot.create :user, username: "emadj"
    recording = FactoryBot.create :recording, radio: @radio
    @scheduled_show = ScheduledShow.create! radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "hey hey", dj: @dj
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s, :preserve_exact_body_bytes => true) do
      ProcessRecording.new.perform recording, @scheduled_show
    end

    expect(@scheduled_show.tracks.count).to eq 1
    track = @scheduled_show.tracks.first

    expect(File.basename(track.audio_file_name)).to eq File.basename(recording.path)
    expect(track.uploaded_by).to eq user
  end

  # TODO
  xit 'doesnt create duplicate if existing track exists'
end
