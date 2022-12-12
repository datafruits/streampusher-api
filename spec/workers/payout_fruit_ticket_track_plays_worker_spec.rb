require 'rails_helper'
require 'sidekiq/testing'

describe PayoutFruitTicketTrackPlaysWorker do
  include RedisConnection

  before do
    Sidekiq::Testing.inline!
  end
  before :each do
    host = ENV['REDIS_HOST'] || 'redis'
    port = ENV['REDIS_PORT'] || 6379
    Redis.current.flushall
  end
  it "pays out royalties for track plays" do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 0
    playlist = FactoryBot.create :playlist, radio: radio
    scheduled_show = FactoryBot.create :scheduled_show, dj: user, start_at: 2.days.from_now, end_at: 3.days.from_now, playlist: playlist, radio: radio
    track = FactoryBot.create :track, scheduled_show: scheduled_show, radio: radio
    redis.hset("datafruits:track_plays", track.id, 3)
    PayoutFruitTicketTrackPlaysWorker.perform_now
    user.reload
    expect(user.fruit_ticket_balance).to eq 3
  end
end
