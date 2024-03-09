class FruitTicketTransaction < ApplicationRecord
  belongs_to :from_user, class_name: "User" # null means the website gave you fruit tickets
  belongs_to :to_user, class_name: "User" # null means bought something from the website

  validate :to_or_from_user_is_present
  validates :amount,
    numericality: { only_integer: true, greater_than: 0 },
    if: Proc.new { |t| !t.fruit_summon? }

  after_create :maybe_send_notification

  # how do you get fruit tickets
  #   - people listen to your show
  #   - 1 fruit ticket for every listener?
  #   - 1 fruit ticket per archive playback
  #   - donate to patreon/ampled
  #   - commit on github
  #
  enum transaction_type: [
    # receiving
    :show_listeners_count, # how ?
    :archive_playback, # 1 ticket per playback
    :supporter_membership,
    :code_contribution,

    # purchase
    :fruit_summon, # metal pineapple, real lemoner, XL shrimp shake
    :profile_sticker,

    :user_gift,

    :shrimpo_deposit,
    :shrimpo_deposit_return,
    :shrimpo_award,
    :shrimpo_playback,
  ]

  def transact_and_save!
    ActiveRecord::Base.transaction do
      if self.valid?
        case self.transaction_type
        when "fruit_summon"
          # check if user's balance is enough
          fruit_summon_entity = FruitSummonEntity.find(source_id)
          raise "invalid fruit summon" unless fruit_summon_entity
          self.amount = fruit_summon_entity.cost
          self.to_user_id = -1
          if self.from_user.fruit_ticket_balance < self.amount
            raise "not enough balance"
          end
          self.from_user.update fruit_ticket_balance: self.from_user.fruit_ticket_balance - self.amount
          self.save!
        when "supporter_membership"
          self.from_user_id = -1
          self.to_user.update fruit_ticket_balance: self.to_user.fruit_ticket_balance + self.amount
          self.save!
        when "archive_playback"
          self.from_user_id = -1
          self.to_user.update fruit_ticket_balance: self.to_user.fruit_ticket_balance + self.amount
          self.save!
        when "user_gift"
          if self.from_user.fruit_ticket_balance < self.amount
            raise "not enough balance"
          end
          self.from_user.update fruit_ticket_balance: self.from_user.fruit_ticket_balance - self.amount
          self.to_user.update fruit_ticket_balance: self.to_user.fruit_ticket_balance + self.amount
          self.save!
        when "shrimpo_deposit"
          if self.from_user.fruit_ticket_balance < self.amount
            raise "not enough balance"
          end
          self.from_user.update fruit_ticket_balance: self.from_user.fruit_ticket_balance - self.amount
          self.save!
        when "shrimpo_deposit_return"
          self.to_user.update fruit_ticket_balance: self.to_user.fruit_ticket_balance + self.amount
          self.save!
        else
          raise "invalid transaction_type"
        end
      else
        raise ActiveRecord::RecordInvalid
      end
    end
  end

  private
  def to_or_from_user_is_present
    if !from_user_id.present? && !to_user_id.present?
      errors.add(:from_user, "from_user to to_user must be present")
    end
  end

  def maybe_send_notification
    case self.transaction_type
    when "user_gift"
      Notification.create! source: self, send_to_chat: false, user: to_user, notification_type: "fruit_ticket_gift"
    when "supporter_membership"
      Notification.create! source: self, send_to_chat: false, user: to_user, notification_type: "supporter_fruit_ticket_stipend"
    end
  end
end
