require 'rails_helper'

describe SaveRecording do
  xit "saves a new recording model given a path and radio" do
    radio = FactoryGirl.create :radio, name: "datafruits"
    filename = "/home/liquidsoap/tracks/unhappy_supermarket_lektro.mp3"
    FileUtils.copy "spec/fixtures/unhappy_supermarket_lektro.mp3", radio.tracks_directory
    VCR.use_cassette "save_recording", :match_requests_on => [:method, :s3_uri_matcher] do
      RadioBooter.boot radio

      recording = SaveRecording.save filename, radio.name
      expect(recording.file_file_size).to eq File.size(File.join(radio.tracks_directory, File.basename(filename)))
    end
  end
end
