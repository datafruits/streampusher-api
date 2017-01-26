describe UploadTrackToSoundcloud do
  let(:token){ ENV['SOUNDCLOUD_TOKEN'] }
  before do
    Sidekiq::Testing.inline!
  end

  it "uploads track to soundcloud account" do
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
      track = FactoryGirl.create :track, audio_file_name: "https://s3.amazonaws.com/streampushertest/datafruits-ovenrake-12-01-2015.mp3", artwork: File.new(File.join(Rails.root.to_s, "spec/fixtures/images/artwork2.png"))
    end
  end
end
