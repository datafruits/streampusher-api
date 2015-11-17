require 'factory_girl'

FactoryGirl.define do
  factory :track do
    association :radio
  end
end
