require 'rails_helper'

RSpec.describe FruitTicketTransaction, type: :model do
  it 'completes the transaction and saves the model' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 500

    fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :fruit_summon, amount: 200, from_user_id: user.id

    fruit_ticket_transaction.transact_and_save!
  end

  it 'raises not enough balance error' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 100

    fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :fruit_summon, amount: 200, from_user_id: user.id

    expect do
      fruit_ticket_transaction.transact_and_save!
    end.to raise_error
  end

  it 'raises invalid transaction_type error' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 500

    fruit_ticket_transaction = FruitTicketTransaction.new amount: 200, from_user_id: user.id

    expect do
      fruit_ticket_transaction.transact_and_save!
    end.to raise_error
  end
end
