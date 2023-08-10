require 'rails_helper'

describe FruitTicketTransaction do
  it 'saves a new fruit summon and fruit ticket transaction' do
    radio = FactoryBot.create :radio
    user = FactoryBot.create :user, fruit_ticket_balance: 500
    entity = FruitSummonEntity.create!(name: 'metal_pineaple', cost: 200)

    fruit_summon = FruitSummonTransaction.perform 'metal_pineaple', user

    expect(fruit_summon.persisted?).to eq true
    expect(fruit_summon.user).to eq user
    expect(fruit_summon.fruit_summon_entity).to eq entity
  end

  xit 'rollsback if anything fails'
end
