require 'factory_girl'

FactoryBot.define do
  factory :playlist do
    name :my_playlist
    association :radio
  end
end
