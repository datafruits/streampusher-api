require 'rails_helper'
require 'sidekiq/testing'
require 'webmock/rspec'

describe DownloadTrackWorker do
  before do
    Sidekiq::Testing.inline!
  end
  after do
    Sidekiq::Testing.disable!
  end

  xit "downloads the tracks file" do
    url = "https://archive.org/download/KmartDecember1990/KmartDecember1990.ogg"
    body = "nonononononononono"
    stub_request(:any, url).
      to_return(body: body)
    track = double("track")
    allow(track).to receive(:audio_file_name) { url }
    allow(track). to receive(:local_path) { "/tmp/KmartDecember1990.ogg" }
    allow(Track).to receive(:find_by!) { track }

    DownloadTrackWorker.new.perform 1
    expect(File.read("/tmp/KmartDecember1990.ogg")).to eq body
  end
end
