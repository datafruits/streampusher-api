class DailyGlorpLotteryWorker < ActiveJob::Base
  include RedisConnection
  queue_as :default

  def perform
    # 1 in 20 chance of getting a glop or glorp?
    chance = rand(100)
    prize = nil
    if chance <= 30
      # congratulations, you've won :glorp:
      prize = :glorppy
      puts "today's prize is #{prize}!"
    elsif chance >= 80
      # congratulations, you've won :glop:
      prize = :gloppy
      puts "today's prize is #{prize}!"
    else
      puts "no winner today!"
    end
 
    if prize
      # pick random winner
      winner_username = current_chat_users.sample
      winner = User.find_by(username: winner_username)
      if winner
        puts "the winner is: #{winner.username}"
        ExperiencePointAward.create! award_type: prize, user: winner, amount: rand(5)
      end
    end

    def current_chat_users
      sockets = redis.smembers "datafruits:chat:sockets"
      usernames = sockets.map { |s| s.split(":").last }
      return usernames.filter do |u|
        User.where(username: u).any?
      end
    end
  end
end
