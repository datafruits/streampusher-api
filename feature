User
  has_one :subscription

Subscription

Plan

RadioServer
  belongs_to :user, though:
  belongs_to :subscription

Stream
  url
