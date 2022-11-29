class SupportersMonthlyFruitTicketsWorker
  def perform radio
    radio.users.where("role like (?)", "%supporter%") do |user|
      fruit_ticket_transaction = FruitTicketTransaction.new to_user: user, amount: 1000
      fruit_ticket_transaction.transact_and_save!
    end
  end
end
