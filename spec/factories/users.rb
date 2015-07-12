require 'factory_girl'

FactoryGirl.define do
  factory :user do
    username 'yoshibo'
    time_zone 'Tokyo'
    email 'yoshino@malboro.info'
    password "password"
    password_confirmation "password"
  end
end
