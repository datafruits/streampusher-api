require 'rails_helper'

describe BadgeAwardsWorker do
  include RedisConnection
  it 'awards a fruit badge if threshold passed' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user
    redis.hset "datafruits:user_fruit_count:#{user.username}", "strawberry", 50_000

    BadgeAwardsWorker.perform_now radio.id
    user.reload
    expect(user.roles).to include("strawberry")
  end
end
