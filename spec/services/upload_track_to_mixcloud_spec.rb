require 'spec_helper'

describe UploadTrackToMixcloud do
  it "uploads a track to mixcloud account" do
    # track = FactoryGirl.create :track

    UploadTrackToMixcloud.perform track, token
  end

  it "errors if credentials are invalid"
  it "errors if upload fails"
end
