class FruitSummon < ApplicationRecord
  belongs_to :fruit_ticket_transaction
  belongs_to :fruit_summon_entity
  belongs_to :user
end
