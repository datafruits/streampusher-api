require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ScheduledShow, :type => :model do
  before do
    Sidekiq::Testing.inline!

    @radio = Radio.create name: 'datafruits', subscription_id: 1
    @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    @playlist = Playlist.create radio: @radio, name: "big tunes"
    @start_at = Chronic.parse("today at 1:15 pm").utc
    @end_at = Chronic.parse("today at 3:15 pm").utc
    @date = Date.today.strftime("%m%d%Y")
  end

  describe "override time zone" do
    it "set time_zone to save in" do
      Time.use_zone "Tokyo" do
        Timecop.travel Time.zone.parse("2090-01-01 08:00") do
          start_at = Time.zone.parse("2090-02-01 09:00")
          end_at = Time.zone.parse("2090-02-01 11:00")

          time_zone = "Eastern Time (US & Canada)"
          @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, time_zone: time_zone, title: "my show with dj steve martin"

          format = "%a, %d %b %Y %H:%M:%S"
          expect(@scheduled_show.start_at).to eq start_at.strftime(format).in_time_zone(time_zone)
          expect(@scheduled_show.end_at).to eq end_at.strftime(format).in_time_zone(time_zone)
        end
      end
    end
  end

  describe "validations" do
    it "start time cannot be in the past" do
      start_at = Chronic.parse("yesterday at 3:15 pm").utc
      end_at = Chronic.parse("today at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey"
      expect(@scheduled_show.errors[:start_at]).to be_present
    end
    it "end time cannot be in the past" do
      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("2 days ago at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey"
      expect(@scheduled_show.errors[:end_at]).to be_present
    end
    it "end time cannot be before start time" do
      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("today at 2:15 pm").utc
      @scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey"
      expect(@scheduled_show.errors[:end_at]).to be_present
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
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey"
      expect(ScheduledShow.where("start_at >= (?) AND start_at <= (?)", start_at.beginning_of_month, start_at.end_of_month).count).to eq 1
      expect(recurring_show.recurrences.count).to eq 275

      start_at = Chronic.parse("today at 3:15 pm").utc
      end_at = Chronic.parse("today at 5:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "week", title: "hey weekly edition"
      expect(ScheduledShow.where(start_at: start_at).count).to eq 1
    end

    it "updates all recurring shows attributes" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "week", title: "hey"
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
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "week", title: "hey"
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
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "week", title: "hey"
      expect(recurring_show.recurrences.count).to eq 1200
      recurring_show.update recurring_interval: "month"
      expect(recurring_show.recurrences.count).to eq 275
    end

    it "deletes all recurring shows if destroy_recurrences is set" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey"
      recurring_show.destroy_recurrences = true
      recurring_show.destroy
      expect(recurring_show.recurrences.count).to eq 0
    end

    it "doesn't delete all recurring shows if destroy_recurrences is not set" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey"
      recurring_show.destroy
      expect(recurring_show.recurrences.count).to eq 275
    end

    it "only deletes recurring shows in the future" do
      start_at = Chronic.parse("today at 1:15 pm").utc
      end_at = Chronic.parse("today at 3:15 pm").utc
      recurring_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, recurring_interval: "month", title: "hey"
      Timecop.travel 6.months.from_now do
        recurring_show.destroy_recurrences = true
        recurring_show.destroy
        expect(recurring_show.recurrences.count).to eq 5
      end
    end
  end
end
