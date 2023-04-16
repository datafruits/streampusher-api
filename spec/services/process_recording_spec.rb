require 'rails_helper'
require 'sidekiq/testing'

describe ProcessRecording do
  before do
    Sidekiq::Testing.inline!
  end
  it 'processes a recording' do
    user = FactoryBot.create :user, username: "emadj"
    recording = FactoryBot.create :recording
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s, :preserve_exact_body_bytes => true) do
      ProcessRecording.new.perform recording
    end
    track = Track.first

    expect(Track.count).to eq 1
    expect(File.basename(track.audio_file_name)).to eq File.basename(recording.path)
    expect(track.uploaded_by).to eq user
  end
end
