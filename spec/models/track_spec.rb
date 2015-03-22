require 'rails_helper'

describe Track do
  it 'gets the local path' do
    track = Track.new audio_file_name: 'http://s3.amazonaws.com/streampusher/doo.mp3'
    allow(track).to receive(:local_directory) { ::Rails.root.join('tmp/datafruits').to_s }
    expect(track.local_path).to eq ::Rails.root.join('tmp/datafruits/doo.mp3').to_s
  end
end
