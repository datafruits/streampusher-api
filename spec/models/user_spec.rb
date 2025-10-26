require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user){ User.create username: "mcfiredrill", time_zone: "Tokyo", role: "admin", email: "mcfiredrill@datafruits.fm", password: "abc12345678" }
  describe "username" do
    it "is set from email if no username is present" do
      user = User.create email: "mcfiredrill@gmail.com", time_zone: "Tokyo", role: "admin"
      expect(user.username).to eq "mcfiredrill"
    end

    it "downcases username" do
      user = User.create username: "McFireDRILl", email: "mcfiredrill@gmail.com", time_zone: "Tokyo", role: "admin"
      expect(user.username).to eq "mcfiredrill"
    end

    it "only allows alphanumeric" do
      user = User.create username: "McFirelLl@gmail.com", email: "mcfiredrill@gmail.com", time_zone: "Tokyo", role: "admin"
      expect(user.valid?).to eq false
      expect(user.errors.messages[:username]).to eq ["must contain only alphanumeric characters"]
    end
  end

  describe "roles" do
    it "adds a new role" do
      user.add_role "dj"
      expect(user.roles.include?("admin")).to eq true
      expect(user.roles.include?("dj")).to eq true
    end

    it "removes a role" do
      user.add_role "supporter"
      expect(user.roles.include?("supporter")).to eq true
      user.add_role "gold_supporter"
      expect(user.roles.include?("gold_supporter")).to eq true
      user.remove_role "supporter"
      expect(user.roles.include?("supporter")).to eq false
    end
  end

  describe "soft delete" do
    it "soft deletes an account" do
      user.soft_delete
      expect(user.deleted_at).to_not eq nil
    end
  end

  describe "default avatar" do
    it "sets a random default avatar if none is set" do
      user = User.create! email: "mcfiredrill@gmail.com", time_zone: "Tokyo", role: "admin", password: "testtest"
      expect(user.image.path).to include("default_avatar")
    end
  end
end
