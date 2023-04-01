require 'rails_helper'

RSpec.describe ExperiencePointAward, type: :model do
  let(:user){ User.create username: "mcfiredrill", time_zone: "Tokyo", role: "admin owner" }
  describe "leveling up" do
    xit "gains multiple levels at once"
    it "raises level by 1 if xp threshold reached" do
      user = FactoryBot.create :user

      ExperiencePointAward.create user: user, amount: 1000, award_type: :music_enjoyer

      expect(user.level).to eq 2
    end
  end
end
