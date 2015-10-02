require 'rails_helper'

RSpec.describe Radio, :type => :model do
  it 'knows where to put the tracks'
  it "knows its default playlist redis key" do
    radio = FactoryGirl.create :radio
  end
end
