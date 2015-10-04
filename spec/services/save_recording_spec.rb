require 'rails_helper'

describe SaveRecording do
  it "saves a new recording model given a path and radio" do
    radio = FactoryGirl.create :radio, name: "datafruits"
    filename = "/home/liquidsoap/tracks/never_enough.mp3"
    VCR.use_cassette "save_recording" do
      RadioBooter.boot radio

      recording = SaveRecording.save filename, radio.name
      expect(recording.file_file_size).to eq File.size(File.join(radio.tracks_directory, File.basename(filename)))
    end
  end
end
