require 'factory_girl'

FactoryBot.define do
  factory :radio do
    name 'datafruits'
    association :subscription
  end
end
