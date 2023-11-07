require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ShowSeries, type: :model do
  describe "recurrences" do
  end

  describe "saving recurrences" do
    before do
      Sidekiq::Testing.inline!
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)

      @radio = Radio.create name: 'datafruits'
      @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    end

    after do
      Timecop.return
      Sidekiq::Testing.disable!
    end

    it "saves recurring shows" do
      show_series = ShowSeries.new title: "monthly jammer jam", description: "wow", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      expect(show_series.episodes.count).to eq 276
      expect(show_series.episodes.future.pluck(:start_at).map {|m| m.hour }.uniq.count).to eq 1
      expect(show_series.episodes.future.pluck(:end_at).map {|m| m.hour }.uniq.count).to eq 1
      expect(show_series.episodes.first.start_at).to eq(Time.zone.parse('2015-01-04'))
      expect(show_series.episodes.first.end_at).to eq(Time.zone.parse('2015-01-04') + 1.hours)

      # test biweek
      show_series = ShowSeries.new title: "biweekly jammer jam", description: "wow", recurring_interval: "biweek", recurring_weekday: "Tuesday", start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      expect(show_series.episodes.count).to eq 600

      # test week
      show_series = ShowSeries.new title: "weekly jammer jam", description: "wow", recurring_interval: "week", recurring_weekday: "Monday", start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      expect(show_series.episodes.count).to eq 1200
    end

    it "saves biweek with start date" do
      # test biweek
      show_series = ShowSeries.new title: "biweekly jammer jam", description: "wow", recurring_interval: "biweek", recurring_weekday: "Tuesday", start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: 1.month.from_now.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      expect(show_series.episodes.count).to eq 598

    end

    it "updates all episodes with new time" do
      show_series = ShowSeries.new title: "monthly jammer jam", description: "wow", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      expect(show_series.episodes.count).to eq 276

      new_start_time =  show_series.start_time + 2.hours
      new_end_time =  show_series.end_time + 2.hours
      show_series.start_time = new_start_time
      show_series.end_time = new_end_time
      show_series.title = "hey"
      show_series.save!
      show_series.reload
      expect(show_series.episodes.first.start_at.hour).to eq new_start_time.hour
    end

    it "handles crossing the DST boundry" do
      Timecop.travel Time.zone.parse("2015-11-13") do
        show_series = ShowSeries.new title: "monthly jammer jam", description: "wow", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month + 1.month, radio: @radio, time_zone: "US/Pacific"
        show_series.users << @dj
        show_series.save!

        pre_dst_start_hour = show_series.episodes.first.start_at.in_time_zone("US/Pacific").hour
        dst_episode = show_series.episodes.where("start_at >= ?", show_series.start_date + 6.months).first
        post_dst_start_hour = dst_episode.start_at.in_time_zone("US/Pacific").hour
        expect(post_dst_start_hour).to eq(pre_dst_start_hour)
      end
    end

    xit 'converts weekly to biweekly' do
      show_series = ShowSeries.new title: "weekly jammer jam", description: "wow", recurring_interval: "week", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      expect(show_series.episodes.count).to eq 1200

      new_start_time = 1.week.from_now
      show_series.convert_to! "biweek", 1.week.from_now
      expect(show_series.reload.episodes.count).to eq 600
      expect(show_series.episodes.future.first.start_at).to eq new_start_time
    end

    xit "creates a unique slug for each recurrence"
    xit "updates all recurring shows attributes"
    xit "doesnt duplicate slugs on update"
  end

  describe "recurring cadence" do
    xit 'validates uniqueness based on month scope' do
      show_a = ShowSeries.create title: "monthly jammer jam", description: "cool", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month
      expect(show_a.valid?).to eq true
      show_b = ShowSeries.new title: "live coding for dogs", description: "yep you heard me", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month
      show_b.validate
      expect(show_b.errors[:recurring_cadence].length).to eq 1
      show_c = ShowSeries.new title: "live coding for dogs", description: "again?", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'Second', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month
      expect(show_c.valid?).to eq true
    end
  end
end
