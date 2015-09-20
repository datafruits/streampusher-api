require 'factory_girl'

FactoryGirl.define do
  factory :radio do
    name 'datafruits'
    association :subscription
  end
end
