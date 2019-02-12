require 'rails_helper'

describe ProcessRecording do
  it 'processes a recording' do
    recording = create :recording
    ProcessRecording.new.perform recording
  end
end
