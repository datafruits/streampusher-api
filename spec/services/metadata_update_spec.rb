require 'rails_helper'
require 'sidekiq/testing'

describe MetadataUpdate do
  let(:radio){ instance_double("Radio") }
  let(:liquidsoap_socket_class){ class_double("Liquidsoap::Socket") }
  let(:liquidsoap_socket){ instance_double("Liquidsoap::Socket") }
  it "sends metadata update command to liquidsoap" do
    allow(radio).to receive(:liquidsoap_socket_path).and_return("/tmp/datafruits.sock")
    allow(liquidsoap_socket_class).to receive(:new).with("/tmp/datafruits.sock").and_return(liquidsoap_socket)
    expect(liquidsoap_socket).to receive(:write).with("metadata.update artist=tony,title=hey,album=my album")
    metadata = { :artist => "tony", :title => "hey", :album => "my album" }
    MetadataUpdate.perform radio, metadata, liquidsoap_socket_class
  end
end
