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

        # we had a 'return' before but that rolls back the transaction for some reason
        # see https://stackoverflow.com/a/73621642
        fruit_summon
      rescue
        puts "fruit summon failed, user #{user.username} entity #{entity.name}"
      end
    end
  end
end
