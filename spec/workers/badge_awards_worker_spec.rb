require 'rails_helper'
require 'sidekiq/testing'

describe BadgeAwardsWorker do
  include RedisConnection

  before do
    Sidekiq::Testing.inline!
  end
  before :each do
    host = ENV['REDIS_HOST'] || 'redis'
    port = ENV['REDIS_PORT'] || 6379
    redis.flushall
  end
  it 'awards a fruit badge if threshold passed' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user
    user.radios << radio
    user.save!
    redis.hset "datafruits:user_fruit_count:#{user.username}", "strawberry", 50_000

    BadgeAwardsWorker.perform_now radio.id
    user.reload
    expect(user.roles).to include("strawberry")
  end
end
