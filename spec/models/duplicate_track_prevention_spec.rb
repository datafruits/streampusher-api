require 'rails_helper'

describe "Duplicate track prevention" do
  let(:radio) { FactoryBot.create :radio }
  let(:user) { FactoryBot.create :user }
  let(:playlist) { FactoryBot.create :playlist, radio: radio }
  let(:show_series) { FactoryBot.create :show_series, radio: radio }
  let(:start_at) { Time.current + 1.hour }
  let(:end_at) { start_at + 1.hour }
  
  let(:scheduled_show) do
    FactoryBot.create :scheduled_show,
                      radio: radio,
                      playlist: playlist,
                      show_series: show_series,
                      start_at: start_at,
                      end_at: end_at,
                      title: "Test Show",
                      dj: user
  end

  let(:recording) do
    FactoryBot.create :recording,
                      radio: radio,
                      dj: user,
                      path: "/tmp/test-recording.mp3"
  end

  before do
    # Create a test file for recording
    FileUtils.mkdir_p('/tmp')
    File.write('/tmp/test-recording.mp3', 'test audio content')
    
    # Mock external dependencies
    allow(Sox).to receive(:trim).and_return('/tmp/test-recording.mp3')
    
    # Mock AWS S3 upload
    s3_client = double('s3_client')
    allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
    allow(s3_client).to receive(:put_object)
    
    # Mock environment variables
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('S3_BUCKET').and_return('test-bucket')
    allow(ENV).to receive(:[]).with('S3_KEY').and_return('test-key')
    allow(ENV).to receive(:[]).with('S3_SECRET').and_return('test-secret')
  end

  after do
    FileUtils.rm_f('/tmp/test-recording.mp3')
  end

  describe "Recording to Track uniqueness" do
    it "prevents multiple tracks from being created for the same recording" do
      # First processing should create a track
      track1 = ProcessRecording.new.perform(recording, scheduled_show)
      expect(track1).to be_persisted
      expect(recording.reload.track).to eq(track1)

      # Second processing should return the existing track, not create a new one
      initial_track_count = Track.count
      track2 = ProcessRecording.new.perform(recording, scheduled_show)
      
      expect(Track.count).to eq(initial_track_count)
      expect(track2).to eq(track1)
      expect(recording.reload.track).to eq(track1)
    end

    it "validates uniqueness of track_id in recordings" do
      track1 = FactoryBot.create :track, radio: radio
      track2 = FactoryBot.create :track, radio: radio
      
      recording1 = FactoryBot.create :recording, radio: radio, dj: user, track: track1
      recording2 = FactoryBot.build :recording, radio: radio, dj: user, track: track1
      
      expect(recording2).not_to be_valid
      expect(recording2.errors[:track_id]).to include("has already been taken")
    end
  end

  describe "Scheduled Show to Track uniqueness" do
    it "prevents duplicate tracks with same audio file for same scheduled show" do
      audio_file_name = "https://test-bucket.s3.amazonaws.com/test-radio/test-recording.mp3"
      
      # Create first track
      track1 = FactoryBot.create :track,
                                 radio: radio,
                                 scheduled_show: scheduled_show,
                                 audio_file_name: audio_file_name

      # Try to create second track with same audio file for same scheduled show
      track2 = FactoryBot.build :track,
                                radio: radio,
                                scheduled_show: scheduled_show,
                                audio_file_name: audio_file_name

      expect(track2).not_to be_valid
      expect(track2.errors[:audio_file_name]).to include("already exists for this scheduled show")
    end

    it "allows same audio file for different scheduled shows" do
      scheduled_show2 = FactoryBot.create :scheduled_show,
                                          radio: radio,
                                          playlist: playlist,
                                          show_series: show_series,
                                          start_at: start_at + 2.hours,
                                          end_at: end_at + 2.hours,
                                          title: "Test Show 2",
                                          dj: user

      audio_file_name = "https://test-bucket.s3.amazonaws.com/test-radio/test-recording.mp3"
      
      # Create track for first show
      track1 = FactoryBot.create :track,
                                 radio: radio,
                                 scheduled_show: scheduled_show,
                                 audio_file_name: audio_file_name

      # Create track for second show with same audio file should be allowed
      track2 = FactoryBot.build :track,
                                radio: radio,
                                scheduled_show: scheduled_show2,
                                audio_file_name: audio_file_name

      expect(track2).to be_valid
    end

    it "allows tracks without scheduled_show to have duplicate audio files" do
      audio_file_name = "https://test-bucket.s3.amazonaws.com/test-radio/test-recording.mp3"
      
      track1 = FactoryBot.create :track,
                                 radio: radio,
                                 scheduled_show: nil,
                                 audio_file_name: audio_file_name

      track2 = FactoryBot.build :track,
                                radio: radio,
                                scheduled_show: nil,
                                audio_file_name: audio_file_name

      expect(track2).to be_valid
    end
  end

  describe "ProcessRecording idempotency" do
    before do
      # Mock the filename parsing
      basename = "datafruits-testuser-20241230-12-00-00.mp3"
      allow(File).to receive(:basename).and_return(basename)
      allow(User).to receive(:find_by).with(username: "testuser").and_return(user)
    end

    it "returns existing track when processing same recording multiple times" do
      # First call creates track
      track1 = ProcessRecording.new.perform(recording, scheduled_show)
      expect(track1).to be_persisted
      expect(scheduled_show.tracks).to include(track1)

      initial_track_count = Track.count
      
      # Second call should return existing track
      track2 = ProcessRecording.new.perform(recording, scheduled_show)
      
      expect(Track.count).to eq(initial_track_count)
      expect(track2).to eq(track1)
    end

    it "returns existing track when same audio file already exists for scheduled show" do
      audio_file_name = "https://test-bucket.s3.amazonaws.com/test-radio/datafruits-testuser-20241230-12-00-00.mp3"
      
      # Create existing track manually
      existing_track = FactoryBot.create :track,
                                         radio: radio,
                                         scheduled_show: scheduled_show,
                                         audio_file_name: audio_file_name

      initial_track_count = Track.count
      
      # Processing should return existing track, not create new one
      track = ProcessRecording.new.perform(recording, scheduled_show)
      
      expect(Track.count).to eq(initial_track_count)
      expect(track).to eq(existing_track)
      expect(recording.reload.track).to eq(existing_track)
    end
  end
end