require 'rails_helper'

RSpec.describe "Duplicate track prevention fixes" do
  describe "Track model validations" do
    it "prevents duplicate audio_file_name for same scheduled_show_id" do
      # This test validates our added validation in Track model
      # validates :audio_file_name, uniqueness: { scope: :scheduled_show_id }
      
      # We expect this validation to be present in the Track model
      track_validations = Track.validators_on(:audio_file_name)
      uniqueness_validator = track_validations.find { |v| v.is_a?(ActiveRecord::Validations::UniquenessValidator) }
      
      expect(uniqueness_validator).to be_present
      expect(uniqueness_validator.options[:scope]).to eq(:scheduled_show_id)
      expect(uniqueness_validator.options[:message]).to eq("already exists for this scheduled show")
    end
  end

  describe "Recording model validations" do
    it "prevents duplicate track_id" do
      # This test validates our added validation in Recording model
      # validates :track_id, uniqueness: true
      
      recording_validations = Recording.validators_on(:track_id)
      uniqueness_validator = recording_validations.find { |v| v.is_a?(ActiveRecord::Validations::UniquenessValidator) }
      
      expect(uniqueness_validator).to be_present
      expect(uniqueness_validator.options[:allow_nil]).to eq(true)
    end
  end

  describe "Database migrations" do
    it "adds unique index on recordings.track_id" do
      # Check if our migration added the unique index
      indexes = ActiveRecord::Base.connection.indexes(:recordings)
      track_id_index = indexes.find { |idx| idx.columns == ['track_id'] && idx.unique }
      
      expect(track_id_index).to be_present
      expect(track_id_index.name).to eq("index_recordings_on_track_id_unique")
    end

    it "adds unique index on tracks (scheduled_show_id, audio_file_name)" do
      # Check if our migration added the unique composite index
      indexes = ActiveRecord::Base.connection.indexes(:tracks)
      composite_index = indexes.find do |idx| 
        idx.columns == ['scheduled_show_id', 'audio_file_name'] && idx.unique
      end
      
      expect(composite_index).to be_present
      expect(composite_index.name).to eq("index_tracks_on_scheduled_show_id_and_audio_file_name_unique")
    end
  end

  describe "ProcessRecording service improvements" do
    let(:mock_recording) { double('Recording', track: nil, update: true) }
    let(:mock_scheduled_show) { double('ScheduledShow', id: 123, tracks: double('tracks'), formatted_episode_title: "Test Show") }
    
    before do
      # Mock external dependencies to focus on our logic
      allow(Sox).to receive(:trim).and_return('/tmp/test.mp3')
      allow(File).to receive(:basename).and_return('datafruits-testuser-20241230.mp3')
      allow(File).to receive(:open).and_return(double('file'))
      
      # Mock AWS
      s3_client = double('s3_client')
      allow(Aws::S3::Client).to receive(:new).and_return(s3_client)
      allow(s3_client).to receive(:put_object)
      
      # Mock environment
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('S3_BUCKET').and_return('test-bucket')
      allow(ENV).to receive(:[]).with('S3_KEY').and_return('test-key') 
      allow(ENV).to receive(:[]).with('S3_SECRET').and_return('test-secret')
      
      # Mock other dependencies
      allow(User).to receive(:find_by).and_return(double('User'))
      allow(StreamingExpAwardWorker).to receive_message_chain(:set, :perform_later)
    end

    it "includes idempotency check for existing track" do
      # Test that our idempotency improvement is in the code
      existing_track = double('Track', id: 456)
      allow(mock_recording).to receive(:track).and_return(existing_track)
      
      service = ProcessRecording.new
      
      # Expect early return when track already exists
      expect(mock_recording).to receive(:update).with(processing_status: 'processed')
      expect(Rails.logger).to receive(:info).with(/already has track/)
      
      result = service.perform(mock_recording, mock_scheduled_show)
      expect(result).to eq(existing_track)
    end

    it "includes duplicate audio file detection" do
      # Test that our duplicate detection logic is in the code
      audio_file_name = "https://test-bucket.s3.amazonaws.com/test-radio/datafruits-testuser-20241230.mp3"
      existing_track = double('Track', id: 789)
      
      allow(mock_recording).to receive(:track).and_return(nil)
      allow(mock_recording).to receive(:radio).and_return(double('Radio', name: 'test-radio', tracks: double('tracks')))
      
      # Mock finding existing track with same audio file
      tracks_relation = double('tracks_relation')
      allow(mock_scheduled_show).to receive(:tracks).and_return(tracks_relation)
      allow(tracks_relation).to receive(:find_by).with(audio_file_name: audio_file_name).and_return(existing_track)
      
      service = ProcessRecording.new
      
      # Expect early return when duplicate audio file found
      expect(Rails.logger).to receive(:info).with(/already exists for scheduled show/)
      expect(mock_recording).to receive(:update).with(processing_status: 'processed', track: existing_track)
      
      result = service.perform(mock_recording, mock_scheduled_show)
      expect(result).to eq(existing_track)
    end
  end
end