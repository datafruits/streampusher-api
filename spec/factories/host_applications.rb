require 'factory_bot'

FactoryBot.define do
  factory :host_application do
    username { 'yoshibo' }
    time_zone { 'Tokyo' }
    email { 'yoshino@malboro.info' }
    link { 'https://soundcloud.com/yoshibo/mymix' }
    desired_time { 2.days.from_now }
    association :radio
  end
end
