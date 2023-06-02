require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ShowSeries, type: :model do
  describe "saving recurrences" do
    before do
      Time.zone = 'UTC'
      Timecop.freeze Time.local(2015)
    end

    after do
      Timecop.return
    end

    xit "saves recurring shows if recurring is true"
    xit "creates a unique slug for each recurrence"
    xit "updates all recurring shows attributes"
    xit "doesnt duplicate slugs on update"
  end

  describe "recurring cadence" do
    it 'validates uniqueness based on month scope' do
      show_a = ShowSeries.create title: "monthly jammer jam", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month
      show_b = ShowSeries.new title: "live coding for dogs", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month
      show_b.validate
      expect(show_b.errors[:recurring_cadence].length).to eq 1
    end
  end
end
