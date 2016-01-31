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
      params = {
                 audio_file_name: 'http://s3.amazonaws.com/streampusher/doo.mp3',
                 labels_attributes: [{ name: "Vaporwave" }, { name: "Garage"}]
               }

      track = Track.create params
      expect(track.labels.first.name).to eq "Vaporwave"
    end
  end
end
