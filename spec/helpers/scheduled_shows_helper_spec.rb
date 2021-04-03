require 'rails_helper'
require 'sidekiq/testing'
require 'date'
RSpec.describe ScheduledShowsHelper, type: :helper do
  before do
    Sidekiq::Testing.inline!

    @radio = Radio.create name: 'datafruits'
    @dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies", time_zone: "UTC"
    @playlist = Playlist.create radio: @radio, name: "big tunes"
    @start_at = Chronic.parse("today at 1:15 pm").utc
    @end_at = Chronic.parse("today at 3:15 pm").utc
    @date = Date.today.strftime("%m%d%Y")
  end

  it 'shows the timezones' do
    start_at = Chronic.parse("today at 3:15 pm").utc
    end_at = Chronic.parse("today at 5:15 pm").utc
    scheduled_show = ScheduledShow.create radio: @radio, playlist: @playlist, start_at: start_at, end_at: end_at, title: "hey hey"
    expect(helper.timezones_text(scheduled_show)).to eq "#{DateTime.now.strftime('%m/%d')} - 07:15 PST - 10:15 EST - 15:15 UK - #{DateTime.tomorrow.strftime('%m/%d')} - 00:15 JST/KST"
  end
end
