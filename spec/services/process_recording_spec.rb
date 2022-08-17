require 'rails_helper'

describe ProcessRecording do
  xit 'processes a recording' do
    recording = FactoryBot.create :recording
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s, :preserve_exact_body_bytes => true) do
      ProcessRecording.new.perform recording
    end
    expect(File.basename(Track.first.audio_file_name)).to eq File.basename(recording.path)
  end
end
