require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user){ User.create username: "mcfiredrill", time_zone: "Tokyo", role: "admin owner" }
  describe "roles" do
    it "adds a new role" do
      user.add_role "dj"
      expect(user.roles.include?("admin")).to eq true
      expect(user.roles.include?("owner")).to eq true
      expect(user.roles.include?("dj")).to eq true
    end
  end
end
