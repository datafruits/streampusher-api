require 'rails_helper'
# warning this was written by copilot

describe CanonicalMetadataSync do
  include RedisConnection

  let(:radio) { FactoryBot.create(:radio) }
  let(:liquidsoap_requests) { instance_double("LiquidsoapRequests") }
  let(:metadata) { "Test Song Title" }

  before do
    # Clear Redis before each test
    redis.flushdb
    
    # Mock LiquidsoapRequests
    allow(LiquidsoapRequests).to receive(:new).with(radio.id).and_return(liquidsoap_requests)
  end

  describe '.perform' do
    context 'with live_dj current source' do
      before do
        allow(liquidsoap_requests).to receive(:current_source).and_return('live_dj')
      end

      it 'sets canonical metadata with live_dj source and current show data' do
        show_series = double('ShowSeries', slug: 'test-show-series')
        current_show = double('ScheduledShow', show_series: show_series, slug: 'test-episode-123')
        
        allow(Radio).to receive(:first).and_return(radio)
        allow(radio).to receive(:current_scheduled_show).and_return(current_show)

        CanonicalMetadataSync.perform(radio.id, metadata)

        stored_data = redis.hgetall("#{radio.name}:canonical_metadata")
        expect(stored_data["title"]).to eq("Test Song Title")
        expect(stored_data["current_source"]).to eq("live_dj")
        expect(stored_data["show_series_id"]).to eq("test-show-series")
        expect(stored_data["episode_id"]).to eq("test-episode-123")
      end

      it 'clears show data when no current show' do
        allow(Radio).to receive(:first).and_return(radio)
        allow(radio).to receive(:current_scheduled_show).and_return(nil)

        CanonicalMetadataSync.perform(radio.id, metadata)

        stored_data = redis.hgetall("#{radio.name}:canonical_metadata")
        expect(stored_data["title"]).to eq("Test Song Title")
        expect(stored_data["current_source"]).to eq("live_dj")
        expect(stored_data["show_series_id"]).to eq("")
        expect(stored_data["episode_id"]).to eq("")
      end
    end

    context 'with scheduled_shows current source' do
      before do
        allow(liquidsoap_requests).to receive(:current_source).and_return('scheduled_shows')
      end

      it 'sets canonical metadata with scheduled_shows source and current show data' do
        show_series = double('ShowSeries', slug: 'scheduled-show-series')
        current_show = double('ScheduledShow', show_series: show_series, slug: 'scheduled-episode-456')
        
        allow(Radio).to receive(:first).and_return(radio)
        allow(radio).to receive(:current_scheduled_show).and_return(current_show)

        CanonicalMetadataSync.perform(radio.id, metadata)

        stored_data = redis.hgetall("#{radio.name}:canonical_metadata")
        expect(stored_data["title"]).to eq("Test Song Title")
        expect(stored_data["current_source"]).to eq("scheduled_shows")
        expect(stored_data["show_series_id"]).to eq("scheduled-show-series")
        expect(stored_data["episode_id"]).to eq("scheduled-episode-456")
      end
    end

    context 'with backup_playlist current source' do
      before do
        allow(liquidsoap_requests).to receive(:current_source).and_return('backup_playlist')
        
        # Set up archive metadata in Redis
        redis.hset("#{radio.name}:current_archive", "show_series", "archive-show-series")
        redis.hset("#{radio.name}:current_archive", "episode", "archive-episode-789")
      end

      it 'sets canonical metadata with backup_playlist source and archive data' do
        CanonicalMetadataSync.perform(radio.id, metadata)

        stored_data = redis.hgetall("#{radio.name}:canonical_metadata")
        expect(stored_data["title"]).to eq("Test Song Title")
        expect(stored_data["current_source"]).to eq("backup_playlist")
        expect(stored_data["show_series_id"]).to eq("archive-show-series")
        expect(stored_data["episode_id"]).to eq("archive-episode-789")
      end

      it 'handles missing archive metadata gracefully' do
        # Clear the archive data
        redis.del("#{radio.name}:current_archive")

        CanonicalMetadataSync.perform(radio.id, metadata)

        stored_data = redis.hgetall("#{radio.name}:canonical_metadata")
        expect(stored_data["title"]).to eq("Test Song Title")
        expect(stored_data["current_source"]).to eq("backup_playlist")
        expect(stored_data["show_series_id"]).to be_nil
        expect(stored_data["episode_id"]).to be_nil
      end
    end

    context 'with unknown current source' do
      before do
        allow(liquidsoap_requests).to receive(:current_source).and_return('unknown')
      end

      it 'sets canonical metadata with unknown source and archive data' do
        redis.hset("#{radio.name}:current_archive", "show_series", "fallback-show-series")
        redis.hset("#{radio.name}:current_archive", "episode", "fallback-episode-999")

        CanonicalMetadataSync.perform(radio.id, metadata)

        stored_data = redis.hgetall("#{radio.name}:canonical_metadata")
        expect(stored_data["title"]).to eq("Test Song Title")
        expect(stored_data["current_source"]).to eq("unknown")
        expect(stored_data["show_series_id"]).to eq("fallback-show-series")
        expect(stored_data["episode_id"]).to eq("fallback-episode-999")
      end
    end

    it 'strips whitespace from metadata title' do
      allow(liquidsoap_requests).to receive(:current_source).and_return('backup_playlist')
      
      CanonicalMetadataSync.perform(radio.id, "  Spaced Title  ")

      stored_data = redis.hgetall("#{radio.name}:canonical_metadata")
      expect(stored_data["title"]).to eq("Spaced Title")
    end

    it 'finds the correct radio by id' do
      # Create a second radio to ensure we're finding the right one
      radio2 = FactoryBot.create(:radio, name: 'second_radio')
      liquidsoap_requests2 = instance_double("LiquidsoapRequests")
      allow(LiquidsoapRequests).to receive(:new).with(radio2.id).and_return(liquidsoap_requests2)
      allow(liquidsoap_requests2).to receive(:current_source).and_return('backup_playlist')
      
      CanonicalMetadataSync.perform(radio2.id, "Radio 2 Song")

      # Verify data is stored for the correct radio
      stored_data = redis.hgetall("#{radio2.name}:canonical_metadata")
      expect(stored_data["title"]).to eq("Radio 2 Song")
      
      # Verify the first radio doesn't have this data
      first_radio_data = redis.hgetall("#{radio.name}:canonical_metadata")
      expect(first_radio_data["title"]).not_to eq("Radio 2 Song")
    end
  end
end