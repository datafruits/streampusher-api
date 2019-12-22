require 'factory_girl'

FactoryGirl.define do
  factory :recording do
    association :radio
    path Rails.root.join("spec/fixtures/datafruits-emadj-10-29-2018-18:59:38.mp3")
  end
end
