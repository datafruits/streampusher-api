require 'factory_girl'

FactoryGirl.define do
  factory :subscription do
    plan_id 1
    association :user, factory: :owner
  end
end
