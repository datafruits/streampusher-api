require 'rails_helper'

RSpec.describe UserEmoji, type: :model do
  def create_user(role:, level: 0)
    User.create!(
      username: "testuser_#{SecureRandom.hex(4)}",
      time_zone: "Tokyo",
      role: role,
      email: "testuser_#{SecureRandom.hex(4)}@example.com",
      password: "abc12345678"
    ).tap { |u| u.update_column(:level, level) }
  end

  describe "validations" do
    context "when user does not have the DJ role" do
      it "is invalid" do
        user = create_user(role: "listener", level: 5)
        emoji = user.user_emojis.build(name: "smile")
        expect(emoji).not_to be_valid
        expect(emoji.errors[:base]).to include("User must have the DJ role")
      end
    end

    context "when user has the DJ role" do
      context "and has no emoji slots (level < 3)" do
        it "is invalid" do
          user = create_user(role: "dj", level: 2)
          emoji = user.user_emojis.build(name: "smile")
          expect(emoji).not_to be_valid
          expect(emoji.errors[:base]).to include("No emoji slots available")
        end
      end

      context "and has emoji slots available" do
        it "is valid" do
          user = create_user(role: "dj", level: 3)
          emoji = user.user_emojis.build(name: "smile")
          expect(emoji).to be_valid
        end
      end

      context "and has used all emoji slots" do
        it "is invalid when no slots remain" do
          user = create_user(role: "dj", level: 3) # 1 slot at level 3
          user.user_emojis.create!(name: "smile")
          emoji = user.user_emojis.build(name: "wink")
          expect(emoji).not_to be_valid
          expect(emoji.errors[:base]).to include("No emoji slots available")
        end
      end
    end
  end

  describe "#emoji_slots" do
    it "returns 0 for a non-DJ user" do
      user = create_user(role: "listener", level: 10)
      expect(user.emoji_slots).to eq(0)
    end

    it "returns 0 for a DJ below level 3" do
      user = create_user(role: "dj", level: 2)
      expect(user.emoji_slots).to eq(0)
    end

    it "returns 1 slot at level 3" do
      user = create_user(role: "dj", level: 3)
      expect(user.emoji_slots).to eq(1)
    end

    it "returns 3 slots at level 4" do
      user = create_user(role: "dj", level: 4)
      expect(user.emoji_slots).to eq(3)
    end

    it "returns 5 slots at level 5" do
      user = create_user(role: "dj", level: 5)
      expect(user.emoji_slots).to eq(5)
    end

    it "caps at level 30" do
      user_30 = create_user(role: "dj", level: 30)
      user_50 = create_user(role: "dj", level: 50)
      expect(user_50.emoji_slots).to eq(user_30.emoji_slots)
    end
  end
end
