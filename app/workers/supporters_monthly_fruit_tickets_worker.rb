class SupportersMonthlyFruitTicketsWorker < ActiveJob::Base
  queue_as :default

  def perform radio_id
    Radio.find(radio_id).users.where("role like (?)", "%supporter%") do |user|
      puts "giving tickets to #{user.username}"
      fruit_ticket_transaction = FruitTicketTransaction.new to_user: user, amount: 1000, transaction_type: :supporter_membership
      fruit_ticket_transaction.transact_and_save!
      puts "done"
    end
  end
end
