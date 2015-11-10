require 'rails_helper'

RSpec.describe Radio, :type => :model do
  it 'knows where to put the tracks'
  it "knows its default playlist redis key" do
    radio = FactoryGirl.create :radio
  end

  it "spaces aren't allowed in the name" do
    radio = FactoryGirl.build :radio, name: "pizza party"
    expect(radio.valid?).to eq false
    expect(radio.errors[:name]).to be_present
  end
end
