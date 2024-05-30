require 'rails_helper'

RSpec.describe FruitTicketTransaction, type: :model do
  it 'completes the transaction and saves the model' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 500

    entity = FruitSummonEntity.create!(name: 'metal_pineaple', cost: 200)

    fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :fruit_summon, source_id: entity.id, from_user_id: user.id

    fruit_ticket_transaction.transact_and_save!

    expect(fruit_ticket_transaction.persisted?).to eq true
    expect(user.reload.fruit_ticket_balance).to eq 300

    expect(fruit_ticket_transaction.to_user_id).to eq(-1)
  end

  it 'gives supporter_membership tickets' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user

    fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :supporter_membership, amount: 1000, to_user: user

    fruit_ticket_transaction.transact_and_save!

    expect(fruit_ticket_transaction.persisted?).to eq true
    expect(user.reload.fruit_ticket_balance).to eq 1000

    expect(fruit_ticket_transaction.from_user_id).to eq(-1)
  end

  it 'raises fruit summon not found error' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 500

    fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :fruit_summon, source_id: 5, from_user_id: user.id

    expect do
      fruit_ticket_transaction.transact_and_save!
    end.to raise_error
  end

  it 'raises not enough balance error' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 100

    entity = FruitSummonEntity.create!(name: 'metal_pineaple', cost: 200)

    fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :fruit_summon, source_id: entity.id, from_user_id: user.id

    expect do
      fruit_ticket_transaction.transact_and_save!
    end.to raise_error
  end

  it 'raises invalid transaction_type error' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 500

    fruit_ticket_transaction = FruitTicketTransaction.new from_user_id: user.id

    expect do
      fruit_ticket_transaction.transact_and_save!
    end.to raise_error
  end

  it 'requires a sender or receiver' do
    radio = FactoryBot.create :radio

    entity = FruitSummonEntity.create!(name: 'metal_pineaple', cost: 200)

    fruit_ticket_transaction = FruitTicketTransaction.new transaction_type: :fruit_summon, source_id: entity.id

    expect do
      fruit_ticket_transaction.transact_and_save!
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'sends fruit ticket gifts to another user' do
    radio = FactoryBot.create :radio
    user1 = FactoryBot.create :user
    user2 = FactoryBot.create :user, email: "tttt@tv.com", username: "fengir"
    user1.update fruit_ticket_balance: 150
    fruit_ticket_transaction = FruitTicketTransaction.new from_user: user1, to_user: user2, amount: 50, transaction_type: :user_gift
    fruit_ticket_transaction.transaction_type = :user_gift
    fruit_ticket_transaction.transact_and_save!
    expect(user1.reload.fruit_ticket_balance).to eq 100
    expect(user2.reload.fruit_ticket_balance).to eq 50
  end

  it "doesn't let you send negative amounts" do
    radio = FactoryBot.create :radio
    user1 = FactoryBot.create :user
    user2 = FactoryBot.create :user, email: "tttt@tv.com", username: "fengir"
    user1.update fruit_ticket_balance: 150
    fruit_ticket_transaction = FruitTicketTransaction.new from_user: user1, to_user: user2, amount: -5000, transaction_type: :user_gift
    fruit_ticket_transaction.transaction_type = :user_gift
    expect(fruit_ticket_transaction.valid?).to eq false
    expect(fruit_ticket_transaction.errors[:amount].length).to eq 1
  end
end
