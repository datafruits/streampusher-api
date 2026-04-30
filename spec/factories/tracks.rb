require 'factory_bot'

FactoryBot.define do
  factory :track do
    association :radio
    sequence(:audio_file_name) { |n| "spec/fixtures/the_cowbell#{n}.mp3" }
    title { "pineapple rules" }
    length { 120 }
  end end
