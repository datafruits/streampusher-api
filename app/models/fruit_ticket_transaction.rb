class FruitTicketTransaction < ApplicationRecord
  belongs_to :from_user, class_name: "User" # null means the website gave you fruit tickets
  belongs_to :to_user, class_name: "User" # null means bought something from the website

  # how do you get fruit tickets
  #   - people listen to your show
  #   - 1 fruit ticket for every listener?
  #   - 1 fruit ticket per archive playback
  #   - donate to patreon/ampled
  #   - commit on github
  #
  enum transaction_type: [
    # receiving
    :show_listeners_count,
    :archive_playback,
    :supporter_membership,
    :code_contribution,

    # purchase
    :fruit_summon, # metal pineapple, real lemoner, XL shrimp shake
    :profile_sticker,
  ]

  def transact_and_save!
    ActiveRecord::Base.transaction do
      case self.transaction_type
      when "fruit_summon"
        # check if user's balance is enough
        fruit_summon_entity = FruitSummonEntity.find(source_id)
        self.amount = fruit_summon_entity.cost
        if self.from_user.fruit_ticket_balance < self.amount
          raise "not enough balance"
        end
        self.from_user.update fruit_ticket_balance: self.from_user.fruit_ticket_balance - self.amount
        self.save!
      when "supporter_membership"
        self.to_user.update fruit_ticket_balance: self.to_user.fruit_ticket_balance + self.amount
        self.save!
      else
        raise "invalid transaction_type"
      end
    end
  end
end
