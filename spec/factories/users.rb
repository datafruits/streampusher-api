require 'factory_bot'

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "yoshibo#{n}" }
    time_zone { 'Tokyo' }
    sequence(:email) { |n| "yoshino#{n}@malboro.info" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :owner, class: User do
    username { 'tony' }
    time_zone { 'Tokyo' }
    email { 'tony@malboro.info' }
    password { "password" }
    password_confirmation { "password" }
    role { "owner dj" }
  end
end
