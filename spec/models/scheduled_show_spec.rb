require 'rails_helper'
require 'sidekiq/testing'
require 'mock_redis'

RSpec.describe ScheduledShow, :type => :model do
  before do
    Sidekiq::Testing.fake!
    Redis.current = MockRedis.new

    @radio = Radio.create name: 'datafruits', subscription_id: 1
    @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    @playlist = Playlist.create radio: @radio, name: "big tunes"
    @show = Show.create dj: @dj, radio: @radio, playlist: @playlist
    @start_at = Chronic.parse("today at 1:15 pm").utc
    @end_at = Chronic.parse("today at 3:15 pm").utc
    @date = Date.today.strftime("%m%d%Y")
  end
  describe "validations" do
    it "start time cannot be in the past" do
      start_at = Chronic.parse("yesterday at 3:15 pm").utc
      end_at = Chronic.parse("today at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at
      expect(@scheduled_show.errors[:start_at]).to be_present
    end
    it "end time cannot be in the past" do
      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("2 days ago at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at
      expect(@scheduled_show.errors[:end_at]).to be_present
    end
    it "end time cannot be before start time" do
      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("today at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at
      expect(@scheduled_show.errors[:end_at]).to be_present
    end
  end
  describe "redis persistence" do
    before do
      Time.zone = 'UTC'
      Timecop.freeze Time.local(1990)
      @scheduled_show = ScheduledShow.create radio: @radio, show: @show, start_at: @start_at, end_at: @end_at
    end

    after do
      Timecop.return
    end

    it 'gets time keys' do
      expect(@scheduled_show.time_keys).to eq ["#{@date}:04h15m", "#{@date}:04h30m", "#{@date}:04h45m", "#{@date}:05h00m",
                                              "#{@date}:05h15m", "#{@date}:05h30m", "#{@date}:05h45m", "#{@date}:06h00m"]
    end

    it "gets redis keys" do
      expect(@scheduled_show.redis_keys).to eq ["#{@radio.name}:schedule:#{@date}:04h15m",
                                                "#{@radio.name}:schedule:#{@date}:04h30m",
                                                "#{@radio.name}:schedule:#{@date}:04h45m",
                                                "#{@radio.name}:schedule:#{@date}:05h00m",
                                                "#{@radio.name}:schedule:#{@date}:05h15m",
                                                "#{@radio.name}:schedule:#{@date}:05h30m",
                                                "#{@radio.name}:schedule:#{@date}:05h45m",
                                                "#{@radio.name}:schedule:#{@date}:06h00m"]
    end

    it "persists to redis" do
      redis = double
      @scheduled_show.redis_keys.each do |key|
        expect(redis).to receive(:set).with(key, @scheduled_show.show.playlist.redis_key)
      end
      @scheduled_show.persist_to_redis redis
    end
  end

  describe "recurring shows" do
    before do
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)
    end

    it "saves recurring shows if recurring is true" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at, recurring_interval: "month"
      expect(recurring_show.recurrences.count).to eq 275
    end

    it "updates all recurring shows attributes" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at, recurring_interval: "week"
      new_start_at = Chronic.parse("today at 11:00 am").utc
      recurring_show.update start_at: new_start_at, update_all_recurrences: true
      recurring_show.recurrences.each do |recurrence|
        expect(recurrence.start_at.hour).to eq new_start_at.hour
        expect(recurrence.start_at.min).to eq new_start_at.min
        expect(recurrence.start_at.sec).to eq new_start_at.sec
      end
    end

    it "updates this recurrance only" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at, recurring_interval: "week"
      new_start_at = Chronic.parse("today at 11:00 am").utc
      recurring_show.update start_at: new_start_at, update_all_recurrences: false
      recurring_show.recurrences.each do |recurrence|
        expect(recurrence.start_at.hour).to eq start_at.hour
        expect(recurrence.start_at.min).to eq start_at.min
        expect(recurrence.start_at.sec).to eq start_at.sec
      end
    end

    it "updates all recurring shows with a new recurrence" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at, recurring_interval: "week"
      expect(recurring_show.recurrences.count).to eq 1201
      recurring_show.update recurring_interval: "month"
      expect(recurring_show.recurrences.count).to eq 275
    end
    it "deletes all recurring shows" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, show: @show, start_at: start_at, end_at: end_at, recurring_interval: "month"
      recurring_show.destroy_all_recurrences
      expect(recurring_show.recurrences.count).to eq 0
    end
  end
end
