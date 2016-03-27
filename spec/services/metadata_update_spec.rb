require 'rails_helper'
require 'sidekiq/testing'

describe MetadataUpdate do
  let(:radio){ FactoryGirl.create :radio }
  it "sends metadata update command to liquidsoap" do
    metadata = { :artist => "tony", :title => "hey", :album => "my album" }
    MetadataUpdate.perform radio, metadata
  end
end
