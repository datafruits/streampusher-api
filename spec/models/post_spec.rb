require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe Post, type: :model do
  before do
    Sidekiq::Testing.inline!
    Time.zone = 'UTC'
    Timecop.freeze Time.local(2015)

    @radio = Radio.create name: 'datafruits'
    @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    @dj2 = User.create role: 'dj', username: 'tonius', email: "tonius@gmail.com", password: "2boobies", time_zone: "UTC"
  end

  after do
    Timecop.return
    Sidekiq::Testing.disable!
  end

  it "creates a notification for show comments" do
    show_series = ShowSeries.new title: "monthly jammer jam", description: "wow", recurring_interval: "month", recurring_weekday: 'Sunday', recurring_cadence: 'First', start_time: Date.today.beginning_of_month, end_time: Date.today.beginning_of_month + 1.hours, start_date: Date.today.beginning_of_month, radio: @radio
    show_series.users << @dj
    show_series.save!

    Post.create! postable: show_series.episodes.last, body: "hello i am tonius", user: @dj2

    notification = Notification.last
    expect(notification.user).to eq @dj
    expect(notification.source).to eq show_series.episodes.last
    expect(notification.url).to eq("https://datafruits.fm/shows/#{show_series.slug}/episodes/#{show_series.episodes.last.slug}")
  end
end
