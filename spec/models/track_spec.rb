require 'rails_helper'
require 'sidekiq/testing'

describe Track do
  before do
    Sidekiq::Testing.fake!
  end

  it 'gets the local path' do
    track = Track.new audio_file_name: 'http://s3.amazonaws.com/streampusher/doo.mp3'
    allow(track).to receive(:local_directory) { ::Rails.root.join('tmp/datafruits').to_s }
    expect(track.local_path).to eq ::Rails.root.join('tmp/datafruits/doo.mp3').to_s
  end

  describe "labels" do
    it "adds a label" do
      radio = FactoryGirl.create :radio
      label = radio.labels.create name: "Vaporwave"
      params = {
                 audio_file_name: 'http://s3.amazonaws.com/streampusher/doo.mp3',
                 label_ids: [label.id]
               }

      track = Track.create params
      expect(track.labels.first.name).to eq "Vaporwave"
    end
  end

  describe "s3_filepath" do
    it "works with both kinds of s3 urls" do
      track = Track.new audio_file_name: "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/datafruits/datafruits-mcfiredrill-09-12-2015-silence-removed.mp3"
      expect(track.s3_filepath).to eq "datafruits/datafruits-mcfiredrill-09-12-2015-silence-removed.mp3"
      track = Track.new audio_file_name: "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/datafruits/datafruits-mcfiredrill-09-12-2015-silence-removed.mp3"
      expect(track.s3_filepath).to eq "datafruits/datafruits-mcfiredrill-09-12-2015-silence-removed.mp3"
    end
  end

  describe "scheduled show" do
    it "pulls tags and artwork from scheduled show if not set" do
      VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
        start_at = Chronic.parse("today at 1:15 pm").utc
        end_at = Chronic.parse("today at 3:15 pm").utc
        radio = Radio.create name: 'datafruits', subscription_id: 1
        track = Track.new audio_file_name: 'http://s3.amazonaws.com/streampusher/doo.mp3'
        scheduled_show = ScheduledShow.create radio: radio, start_at: start_at, end_at: end_at, title: "hey hey", image: File.new("spec/fixtures/images/pineapple.png")
        track.scheduled_show = scheduled_show
        track.save
        formatted_time = scheduled_show.start_at.strftime("%m%d%Y")
        expect(track.title).to eq "hey hey - #{formatted_time}"
      end
    end
  end
end
