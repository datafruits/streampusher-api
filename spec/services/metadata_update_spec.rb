require 'rails_helper'
require 'sidekiq/testing'

describe MetadataUpdate do
  let(:radio){ double }
  it "sends metadata update command to liquidsoap" do
    radio.stub(:liquidsoap_socket_path)
    metadata = { :artist => "tony", :title => "hey", :album => "my album" }
    MetadataUpdate.perform radio, metadata
  end
end
