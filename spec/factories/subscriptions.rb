require 'factory_girl'

FactoryGirl.define do
  factory :subscription do
    association :user, factory: :owner
    association :plan
  end
end
