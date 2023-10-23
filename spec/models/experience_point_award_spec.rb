require 'rails_helper'

RSpec.describe ExperiencePointAward, type: :model do
  let(:user){ User.create username: "mcfiredrill", time_zone: "Tokyo", role: "admin owner" }
  describe "leveling up" do
    it "accumulates xp" do
      user = FactoryBot.create :user

      ExperiencePointAward.create user: user, amount: 1000, award_type: :music_enjoyer
      ExperiencePointAward.create user: user, amount: 1000, award_type: :music_enjoyer
      expect(user.experience_points).to eq 2000
    end
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

  describe "glorpy awards" do
    it "creates a notification that is sent to chat" do
      winner = FactoryBot.create :user
      ExperiencePointAward.create! award_type: :glorppy, user: winner, amount: rand(5) + 1
      expect(Notification.count).to eq 2
      expect(Notification.last.send_to_chat).to eq true
      expect(Notification.last.send_to_user).to eq false

      ExperiencePointAward.create! award_type: :gloppy, user: winner, amount: rand(5) + 1
      expect(Notification.count).to eq 4
      expect(Notification.last.send_to_chat).to eq true
      expect(Notification.last.send_to_user).to eq false
    end
  end
end
