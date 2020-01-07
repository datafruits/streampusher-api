require 'factory_bot'

FactoryBot.define do
  factory :subscription do
    association :user, factory: :owner
    association :plan
  end
end
