require 'factory_girl'

FactoryGirl.define do
  factory :track do
    association :radio
    audio_file_name "spec/fixtures/the_cowbell.mp3"
  end
end
