require 'rails_helper'

describe SaveRecording do
  it "saves a new recording model given a path" do

    SaveRecording.save "datafruits-LIVE -- ovenrake - 06-01-2015, 06:40:56.mp3"
    recording = Recording.last
    expect(recording.
  end
end
