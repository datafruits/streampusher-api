class TreasureChest < ApplicationRecord
  belongs_to :user
  after_create :give_reward

  private
  def give_reward
    case treasure_name
    when "fruit_tickets"
      transaction = FruitTicketTransaction.new amount: self.amount, transaction_type: "treasure_reward", to_user: user
      transaction.transact_and_save!
    when "glorp_points"
      ExperiencePointAward.create! amount: self.amount, award_type: "glorppy", user: user, source: self
    when "bonezo" # nothing
    end
  end
end
