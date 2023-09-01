class FruitTicketTransactionSerializer < ActiveModel::Serializer
  type 'fruit_ticket_gift'
  attributes :amount, :to_user_id
end
