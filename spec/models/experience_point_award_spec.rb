require 'rails_helper'

RSpec.describe ExperiencePointAward, type: :model do
  let(:user){ User.create username: "mcfiredrill", time_zone: "Tokyo", role: "admin owner" }
  describe "leveling up" do
    xit "raises level by 1 if xp threshold reached"
  end
end
