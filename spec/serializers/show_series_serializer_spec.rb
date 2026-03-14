require 'rails_helper'

RSpec.describe ShowSeriesSerializer, type: :serializer do
  before do
    Time.zone = 'UTC'
    Timecop.freeze Time.local(2015)
  end

  after do
    Timecop.return
  end

  let(:radio) { Radio.create! name: 'datafruits' }
  let(:dj) { User.create! role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC" }
  let(:show_series) do
    ss = ShowSeries.new(
      title: "test show",
      description: "a test show",
      recurring_interval: :not_recurring,
      start_time: Date.today.beginning_of_month,
      end_time: Date.today.beginning_of_month + 1.hour,
      start_date: Date.today.beginning_of_month,
      radio: radio,
      time_zone: "UTC"
    )
    ss.users << dj
    ss.save!
    ss
  end

  subject { ShowSeriesSerializer.new(show_series) }

  describe "#thumb_image_url" do
    it "returns nil when no image is attached" do
      expect(subject.thumb_image_url).to be_nil
    end

    it "returns image_url as fallback when ActiveStorage::InvariableError is raised" do
      mock_attachment = double("as_image", present?: true)
      allow(mock_attachment).to receive(:variant).and_raise(ActiveStorage::InvariableError)
      allow(show_series).to receive(:as_image).and_return(mock_attachment)
      allow(subject).to receive(:image_url).and_return("http://example.com/show.png")
      expect(Rails.logger).to receive(:error).with(/Thumbnail processing failed.*test show.*ActiveStorage::InvariableError/)
      expect(subject.thumb_image_url).to eq("http://example.com/show.png")
    end

    it "returns image_url as fallback when ActiveStorage::ProcessingError is raised" do
      mock_attachment = double("as_image", present?: true)
      allow(mock_attachment).to receive(:variant).and_raise(ActiveStorage::ProcessingError)
      allow(show_series).to receive(:as_image).and_return(mock_attachment)
      allow(subject).to receive(:image_url).and_return("http://example.com/show.png")
      expect(Rails.logger).to receive(:error).with(/Thumbnail processing failed.*test show.*ActiveStorage::ProcessingError/)
      expect(subject.thumb_image_url).to eq("http://example.com/show.png")
    end

    it "returns image_url as fallback when MiniMagick::Error is raised" do
      mock_attachment = double("as_image", present?: true)
      allow(mock_attachment).to receive(:variant).and_raise(MiniMagick::Error)
      allow(show_series).to receive(:as_image).and_return(mock_attachment)
      allow(subject).to receive(:image_url).and_return("http://example.com/show.png")
      expect(Rails.logger).to receive(:error).with(/Thumbnail processing failed.*test show.*MiniMagick::Error/)
      expect(subject.thumb_image_url).to eq("http://example.com/show.png")
    end
  end
end
