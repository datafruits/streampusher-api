require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  describe '.friendly_find' do
    thread = ForumThread.create! title: "can glorp do a glorp ?? ! "
    binding.pry
    expect(ForumThread.friendly_find("can a glorp do a glorp ?? ! ")).to eq thread
  end
end
