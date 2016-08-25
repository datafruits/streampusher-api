require 'rails_helper'
require 'sidekiq/testing'

describe UploadTrackToMixcloud do
  let(:token){ ENV['MIXCLOUD_TOKEN'] }
  it "uploads a track to mixcloud account" do
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
    track = FactoryGirl.create :track, audio_file_name: "https://s3.amazonaws.com/streampushertest/datafruits-ovenrake-12-01-2015.mp3"

      expected_response = {"result"=>{"message"=>"Uploaded pineapple rules", "key"=>"/freedrool/pineapple-rules/", "success"=>true}}
      actual_response = UploadTrackToMixcloud.new.perform track, token
      expect(actual_response).to eq expected_response
    end
  end

  it "errors if credentials are invalid"
  it "errors if upload fails"
end
