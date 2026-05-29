class FruitSummon < ApplicationRecord
  include RedisConnection

  belongs_to :fruit_ticket_transaction
  belongs_to :fruit_summon_entity
  belongs_to :user

  after_create :maybe_trigger_hype_meter

  private

  def maybe_trigger_hype_meter
    latest_fruit_summons = FruitSummon.where("created_at > ?", 10.minutes.ago)
    if latest_fruit_summons.count >= 3
      hype_meter_active = redis.get "datafruits:hype_meter_cooldown"
      # only activate if not on cooldown or already active
      if hype_meter_active.nil?
        redis.set "datafruits:hype_meter_status", "active"
        redis.set "datafruits:hype_meter_cooldown", true
        redis.expire "datafruits:hype_meter_cooldown", 900
      end
    end
  end
end
