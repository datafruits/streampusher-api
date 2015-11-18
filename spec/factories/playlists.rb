require 'factory_girl'

FactoryGirl.define do
  factory :playlist do
    name :my_playlist
    association :radio
  end
end
