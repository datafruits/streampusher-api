
require 'factory_bot'

FactoryBot.define do
  factory :podcast do
    name { '1' }
    radio
    playlist
  end
end
