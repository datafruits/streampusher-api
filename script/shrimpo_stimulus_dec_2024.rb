User.where("level >= 1").find_each do |user|
  puts "awarding 5000 tix to #{user.username}"
  amount = 5000  + rand(1..100)
  transaction = FruitTicketTransaction.new to_user: user, transaction_type: :stimulus, amount: amount
  transaction.transact_and_save!
end

User.where("level >= 1").where("role ilike any ( array[?] )", ["%dj%", "%vj%"]).find_each do |user|
  puts "awarding 10000 tix to #{user.username}"
  amount = 10_000  + rand(100..1000)
  transaction = FruitTicketTransaction.new to_user: user, transaction_type: :stimulus, amount: amount
  transaction.transact_and_save!
end

User.where("level >= 1").where("role ilike any ( array[?] )", ["%orange%", "%banana%", "%lemon%", "%watermelon%", "%strawberry%", "%pineapple%", "%limer%"]).find_each do |user|
  puts "awarding 1000 bonus tix to #{user.username}"
  amount = 10_000  + rand(100..1000)
  transaction = FruitTicketTransaction.new to_user: user, transaction_type: :stimulus, amount: amount
  transaction.transact_and_save!
end
