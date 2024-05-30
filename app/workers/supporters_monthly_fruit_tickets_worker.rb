class SupportersMonthlyFruitTicketsWorker < ActiveJob::Base
  queue_as :default

  def perform radio_id
    # TODO duckle tier
    Radio.find(radio_id).users.where("role like (?)", "%supporter%").find_each do |user|
      puts "giving tickets to #{user.username}"
      if user.roles.include?("supporter")
        amount = 700
      elsif user.roles.include?("emerald_supporter")
        amount = 1500
      elsif user.roles.include?("gold_supporter")
        amount = 3000
      end
      fruit_ticket_transaction = FruitTicketTransaction.new to_user: user, amount: amount, transaction_type: :supporter_membership
      fruit_ticket_transaction.transact_and_save!
      puts "done"
    end
  end
end
