class FruitSummonTransaction
  def self.perform name, user
    entity = FruitSummonEntity.find_by(name: name)
    raise "invalid fruit summon" unless entity

    ActiveRecord::Base.transaction do
      begin
        fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :fruit_summon, from_user: user, source_id: entity.id
        fruit_ticket_transaction.transact_and_save!
        fruit_summon = user.fruit_summons.new fruit_ticket_transaction: fruit_ticket_transaction, fruit_summon_entity: entity, user: user
        fruit_summon.save!

        return fruit_summon
      rescue
        puts "fruit summon failed, user #{user.name} entity #{entity.name}"
      end
    end
  end
end
