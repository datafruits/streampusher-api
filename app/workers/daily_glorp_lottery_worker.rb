class DailyGlorpLotteryWorker < ActiveJob::Base
  queue_as :default

  def perform
    # 1 in 20 chance of getting a glop or glorp?
    chance = rand(100)
    prize = nil
    if chance <= 30
      # congratulations, you've won :glorp:
      prize = :glorpy
    elsif chance >= 80
      # congratulations, you've won :glop:
      prize = :gloppy
    end
 
    if prize
      # how to get current chat users???
      current_chat_users = Redis.hget
      winner = current_chat_users
      ExperiencePointAward.create! award_type: prize, user: winner, amount: rand(5)
    end
  end
end
