require 'rails_helper'

RSpec.describe ScheduledShow, :type => :model do
  before do
    @radio = Radio.create name: 'datafruits', subscription_id: 1
    dj = User.create role: 'dj', username: 'dakota', email: "dakota@gmail.com", password: "2boobies"
    playlist = Playlist.create radio: @radio, name: "big tunes"
    show = Show.create dj: dj, radio: @radio, playlist: playlist
    start_at = Chronic.parse("today at 1:15 pm").utc
    end_at = Chronic.parse("today at 3:15 pm").utc
    @date = Date.today.strftime("%m%d%Y")

    @scheduled_show = ScheduledShow.create radio: @radio, show: show, start_at: start_at, end_at: end_at
  end

  it 'gets time keys' do
    expect(@scheduled_show.time_keys).to eq ["#{@date}:04h15m", "#{@date}:04h30m", "#{@date}:04h45m", "#{@date}:05h00m",
                                            "#{@date}:05h15m", "#{@date}:05h30m", "#{@date}:05h45m", "#{@date}:06h00m"]
  end

  it "gets redis keys" do
    expect(@scheduled_show.redis_keys).to eq ["#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:04h15m",
                                              "#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:04h30m",
                                              "#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:04h45m",
                                              "#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:05h00m",
                                              "#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:05h15m",
                                              "#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:05h30m",
                                              "#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:05h45m",
                                              "#{@radio.name}:schedule:#{@scheduled_show.id}:#{@date}:06h00m"]
  end

  it "persists to redis" do
    redis = double
    @scheduled_show.redis_keys.each do |key|
      expect(redis).to receive(:set).with(key, @scheduled_show.show.playlist.redis_key)
    end
    @scheduled_show.persist_to_redis redis
  end
end
