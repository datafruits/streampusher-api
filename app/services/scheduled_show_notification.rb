class ScheduledShowNotification
  def self.perform scheduled_show
    # post to twitter, discord
    if scheduled_show.notify_twitter?
      ScheduledShowNotification::Twitter.perform(scheduled_show)
    end
    # always send to discord
    # ScheduledShowNotification::Discord.perform(scheduled_show)
  end
end
