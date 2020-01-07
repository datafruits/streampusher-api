require 'factory_bot'

FactoryBot.define do
  factory :user do
    username { 'yoshibo' }
    time_zone { 'Tokyo' }
    email { 'yoshino@malboro.info' }
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
