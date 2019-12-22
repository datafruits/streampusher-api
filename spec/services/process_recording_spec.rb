require 'rails_helper'

describe ProcessRecording do
  it 'processes a recording' do
    recording = FactoryGirl.create :recording
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
      ProcessRecording.new.perform recording
    end
    expect(File.basename(Track.first.audio_file_name)).to eq File.basename(recording.path)
  end
end
