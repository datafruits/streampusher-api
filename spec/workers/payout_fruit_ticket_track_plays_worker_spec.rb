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
    redis.flushall
  end
  it "pays out royalties for track plays" do
    VCR.use_cassette(RSpec.current_example.metadata[:full_description].to_s) do
      radio = FactoryBot.create :radio
      user = FactoryBot.create :user, fruit_ticket_balance: 0
      playlist = FactoryBot.create :playlist, radio: radio
      scheduled_show = FactoryBot.create :scheduled_show, dj: user, start_at: 2.days.from_now, end_at: 3.days.from_now, playlist: playlist, radio: radio
      track = FactoryBot.create :track, radio: radio
      redis.hset("datafruits:track_plays", track.id, 3)
      PayoutFruitTicketTrackPlaysWorker.perform_now
      user.reload
      expect(user.fruit_ticket_balance).to eq 3

      fruit_ticket_transaction = FruitTicketTransaction.last
      expect(fruit_ticket_transaction.source_id).to eq track.id
    end
  end
end
