require 'rails_helper'

RSpec.describe ScheduledShow, :type => :model do
  describe "Active Storage and Paperclip image handling" do
    before do
      @radio = Radio.create name: 'datafruits'
      @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
      @playlist = Playlist.create radio: @radio, name: "big tunes"
      @start_at = 1.hour.from_now
      @end_at = 3.hours.from_now
    end

    describe "image methods" do
      context "when no images are attached" do
        it "returns nil for image URLs" do
          show = ScheduledShow.create!(radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "test show", dj: @dj)
          expect(show.image_url).to be_nil
          expect(show.thumb_image_url).to be_nil
        end
      end

      context "when only Active Storage image is attached" do
        it "uses Active Storage for image URLs" do
          show = ScheduledShow.create!(radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "test show", dj: @dj)
          
          # Create a simple test image file
          image_blob = ActiveStorage::Blob.create_and_upload!(
            io: StringIO.new("fake image data"),
            filename: "test.jpg",
            content_type: "image/jpeg"
          )
          show.active_storage_image.attach(image_blob)
          
          expect(show.active_storage_image.attached?).to be true
          expect(show.image_url).to include("rails/active_storage/blobs")
          expect(show.thumb_image_url).to include("rails/active_storage/representations")
        end
      end

      context "when only Paperclip image exists" do
        it "falls back to Paperclip for image URLs" do
          show = ScheduledShow.create!(radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "test show", dj: @dj)
          
          # Simulate Paperclip image by setting the attributes directly
          show.update_columns(
            image_file_name: "test.jpg",
            image_content_type: "image/jpeg",
            image_file_size: 1000,
            image_updated_at: Time.current
          )
          
          expect(show.active_storage_image.attached?).to be false
          expect(show.image).to be_present
          expect(show.image_url).to include(show.image_file_name)
          expect(show.thumb_image_url).to include(show.image_file_name)
        end
      end

      context "when both Active Storage and Paperclip images exist" do
        it "prefers Active Storage over Paperclip" do
          show = ScheduledShow.create!(radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "test show", dj: @dj)
          
          # Add Paperclip image
          show.update_columns(
            image_file_name: "paperclip.jpg",
            image_content_type: "image/jpeg",
            image_file_size: 1000,
            image_updated_at: Time.current
          )
          
          # Add Active Storage image
          image_blob = ActiveStorage::Blob.create_and_upload!(
            io: StringIO.new("fake image data"),
            filename: "active_storage.jpg",
            content_type: "image/jpeg"
          )
          show.active_storage_image.attach(image_blob)
          
          expect(show.active_storage_image.attached?).to be true
          expect(show.image).to be_present
          
          # Should prefer Active Storage
          expect(show.image_url).to include("rails/active_storage/blobs")
          expect(show.image_url).to include("active_storage.jpg")
          expect(show.image_url).not_to include("paperclip.jpg")
        end
      end
    end

    describe "serializer integration" do
      it "uses the model's image methods correctly" do
        show = ScheduledShow.create!(radio: @radio, playlist: @playlist, start_at: @start_at, end_at: @end_at, title: "test show", dj: @dj)
        
        # Add Active Storage image
        image_blob = ActiveStorage::Blob.create_and_upload!(
          io: StringIO.new("fake image data"),
          filename: "serializer_test.jpg",
          content_type: "image/jpeg"
        )
        show.active_storage_image.attach(image_blob)
        
        serializer = ScheduledShowSerializer.new(show)
        
        expect(serializer.image_url).to include("serializer_test.jpg")
        expect(serializer.thumb_image_url).to include("serializer_test.jpg")
        expect(serializer.image_filename).to eq("serializer_test.jpg")
      end
    end
  end
end