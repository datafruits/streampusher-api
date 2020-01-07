require 'factory_bot'

FactoryBot.define do
  factory :radio do
    name 'datafruits'
    association :subscription
  end
end
