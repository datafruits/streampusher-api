require 'factory_bot'

FactoryBot.define do
  factory :scheduled_show do
    title { "hey" }
    association :radio
    association :dj, factory: :user
    playlist { association :playlist, radio: radio }
  end
end
