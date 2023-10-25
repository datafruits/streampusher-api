require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ShowSeries, type: :model do
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

    it 'converts weekly to biweekly' do
      show_series = ShowSeries.new title: "weekly jammer jam", description: "wow", recurring_interval: "week", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
      show_series.users << @dj
      show_series.save!
      expect(show_series.episodes.count).to eq 1200

      show_series.convert_to! "biweek", 1.week.from_now
      expect(show_series.reload.episodes.count).to eq 600
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
