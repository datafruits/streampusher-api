require 'factory_bot'

FactoryBot.define do
  factory :track do
    association :radio
    audio_file_name { "spec/fixtures/the_cowbell.mp3" }
    title { "pineapple rules" }
    length { 120 }
  end
end
