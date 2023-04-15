require 'rails_helper'

RSpec.describe ExperiencePointAward, type: :model do
  let(:user){ User.create username: "mcfiredrill", time_zone: "Tokyo", role: "admin owner" }
  describe "leveling up" do
    it "shows required xp to level up" do
      user = FactoryBot.create :user

      expect(user.level).to eq 0
      expect(user.xp_needed_for_next_level).to eq 32

      ExperiencePointAward.create user: user, amount: 500, award_type: :music_enjoyer
      expect(user.level).to eq 2
      expect(user.xp_needed_for_next_level).to eq 500
    end
    it "gains multiple levels at once" do
      user = FactoryBot.create :user

      ExperiencePointAward.create user: user, amount: 5000, award_type: :music_enjoyer

      expect(user.level).to eq 4
    end
    it "raises level by 1 if xp threshold reached" do
      user = FactoryBot.create :user

      ExperiencePointAward.create user: user, amount: 1000, award_type: :music_enjoyer

      expect(user.level).to eq 3
    end
  end
end
