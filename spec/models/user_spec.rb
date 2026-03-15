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
    xit "sets a random default avatar if none is set" do
      user = User.create! email: "mcfiredrill@gmail.com", time_zone: "Tokyo", role: "admin", password: "testtest"
      expect(user.image.path).to include("default_avatar")
    end
  end

  describe "#thumb_image_url" do
    it "returns nil when no image is attached" do
      user = User.create! username: "noimage", time_zone: "Tokyo", role: "admin", email: "noimage@datafruits.fm", password: "abc12345678"
      expect(user.thumb_image_url).to be_nil
    end

    it "returns image_url as fallback when ActiveStorage::InvariableError is raised" do
      user = User.create! username: "invariable", time_zone: "Tokyo", role: "admin", email: "invariable@datafruits.fm", password: "abc12345678"
      mock_attachment = double("as_image", present?: true, attached?: true)
      allow(mock_attachment).to receive(:variant).and_raise(ActiveStorage::InvariableError)
      allow(user).to receive(:as_image).and_return(mock_attachment)
      allow(user).to receive(:image_url).and_return("http://example.com/avatar.png")
      expect(Rails.logger).to receive(:error).with(/ActiveStorage::InvariableError.*invariable/)
      expect(user.thumb_image_url).to eq("http://example.com/avatar.png")
    end
  end
end
