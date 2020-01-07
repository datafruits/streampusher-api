require 'factory_girl'

FactoryBot.define do
  factory :subscription do
    association :user, factory: :owner
    association :plan
  end
end
