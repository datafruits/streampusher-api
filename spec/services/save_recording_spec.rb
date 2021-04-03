require 'rails_helper'

describe SaveRecording do
  it "saves a new recording model given a path and radio" do
    radio = FactoryBot.create :radio, name: "datafruits"
    shinta = FactoryBot.create :user, username: "shintaro.yonezawa"
    filename = "/home/liquidsoap/tracks/datafruits/datafruits-LIVE -- shintaro.yonezawa - 05-30-2016, 12:12:02.mp3"
    local_path = File.join(radio.tracks_directory, File.basename(filename))
    FileUtils.copy "spec/fixtures/unhappy_supermarket_lektro.mp3", local_path

    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
      recording = SaveRecording.save filename, radio.name
      expect(recording.filesize).to eq File.size(local_path)
      expect(recording.dj).to eq shinta
      expect(recording.radio).to eq radio
    end
  end
end
