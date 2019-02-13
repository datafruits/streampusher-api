require 'factory_girl'

FactoryGirl.define do
  factory :recording do
    association :radio
    path "spec/fixtures/datafruits-LIVE -- emadj - 10-29-2018, 18:59:38.mp3"
  end
end
