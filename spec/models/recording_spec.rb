require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Recording, :type => :model do
  before do
    Sidekiq::Testing.inline!
  end

  it "merges multiple recordings into one file" do
    radio = FactoryGirl.create :radio
    recording1 = FactoryGirl.create :recording, file: File.new("spec/fixtures/the_cowbell.mp3"), radio: radio
    recording2 = FactoryGirl.create :recording, file: File.new("spec/fixtures/wau.mp3"), radio: radio
    Recording.merge recording1, recording2
    new_recording = Recording.last
    expect(new_recording.file_file_name).to eq "the_cowbell.mp3"
    expect(new_recording.radio).to eq recording1.radio
    expect(new_recording.dj).to eq recording1.dj
    expect(new_recording.show).to eq recording1.show
  end

  it "works when recordings are stored on s3" do
    Paperclip::Attachment.default_options.merge!({
      :storage => :s3,
      s3_credentials: {
        access_key_id: ENV['S3_KEY'],
        secret_access_key: ENV['S3_SECRET']
      },
      bucket: ENV['S3_BUCKET']
    })

    VCR.use_cassette "merge recordings when using S3 storage", :match_requests_on => [:method, :s3_uri_matcher] do
      radio = FactoryGirl.create :radio
      recording1 = FactoryGirl.create :recording, file: File.new("spec/fixtures/the_cowbell.mp3"), radio: radio
      recording2 = FactoryGirl.create :recording, file: File.new("spec/fixtures/wau.mp3"), radio: radio
      Recording.merge recording1, recording2
      new_recording = Recording.last
      expect(new_recording.file_file_name).to eq "the_cowbell.mp3"
      expect(new_recording.radio).to eq recording1.radio
      expect(new_recording.dj).to eq recording1.dj
      expect(new_recording.show).to eq recording1.show
    end
  end
end
