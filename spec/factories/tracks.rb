require 'factory_girl'

FactoryGirl.define do
  factory :track do
    association :radio
    audio_file_name "spec/fixtures/the_cowbell.mp3"
    title "pineapple rules"
    artwork File.new("spec/fixtures/images/pineapple.png")
  end
end
