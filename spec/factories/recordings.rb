require 'factory_girl'

FactoryGirl.define do
  factory :recording do
    association :radio
  end
end
