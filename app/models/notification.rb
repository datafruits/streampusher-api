class Notification < ApplicationRecord
  include RedisConnection

  after_create :send_notification
  before_save :set_message

  belongs_to :user
  belongs_to :source, polymorphic: true

  enum notification_type: [
    :strawberry_badge_award,
    :lemon_badge_award,
    :orange_badge_award,
    :banana_badge_award,
    :cabbage_badge_award,
    :watermelon_badge_award,
    :pineapple_badge_award,
    :limer_badge_award,
    :dj_badge_award,
    :vj_badge_award,
    :supporter_badge_award,
    :emerald_supporter_badge_award,
    :gold_supporter_badge_award,
    :duckle_badge_award,
    :level_up,
    :experience_point_award,
    :fruit_ticket_gift,
    :supporter_fruit_ticket_stipend,
    :track_playback_ticket_payment,
    :glorp_lottery_winner,
    :show_comment,
    :patreon_sub,
    :new_thread,
    :new_thread_reply,
    :new_wiki_page,
    :wiki_page_update,
    :new_datafruiter,
    :profile_update,
    :avatar_update,
    :new_podcast,
    :shrimpo_started,
    :shrimpo_deadline_soon,
    :shrimpo_voting_started,
    :shripo_ended,
    :shrimpo_entry,
    :shrimpo_entry_comment,
    :shrimpo_comment,
    :shrimpo_deposit_return,
    :fruit_ticket_stimulus,
    :treasure_fruit_tix_reward,
  ]

  private
  def set_message
    # TODO i18n
    self.message = case self.notification_type
    when "strawberry_badge_award"
      "#{self.user.username} got the strawbur badge!"
    when "lemon_badge_award"
      "#{self.user.username} got the lemoner badge!"
    when "orange_badge_award"
      "#{self.user.username} got the orangey badge!"
    when "banana_badge_award"
      "#{self.user.username} got the banaynay badge!"
    when "cabbage_badge_award"
      "#{self.user.username} got the evil cabbage badge!"
    when "watermelon_badge_award"
      "#{self.user.username} got the watermel badge!"
    when "pineapple_badge_award"
      "#{self.user.username} got the pineapplee badge!"
    when "limer_badge_award"
      "#{self.user.username} got the limer badge!"
    when "dragionfruit badge_award"
      "#{self.user.username} got the dragionfruit badge!"
    when "blueberrinies badge_award"
      "#{self.user.username} got the blueberrinies badge!"
    when "beamsprout_badge_award"
      "#{self.user.username} got the beamsprout badge!"
    when "dj_badge_award"
      "#{self.user.username} got the DJ badge!"
    when "vj_badge_award"
      "#{self.user.username} got the VJ badge!"
    when "supporter_badge_award"
      "#{self.user.username} got the supporter badge!"
    when "gold_supporter_badge_award"
      "#{self.user.username} got the gold supporter badge!"
    when "emerald_supporter_badge_award"
      "#{self.user.username} got the emerald supporter badge!"
    when "duckle_badge_award"
      "#{self.user.username} got the duckle badge! :duckle: what the heck..."
    when "level_up"
      "#{self.user.username} reached level #{self.user.level}!"
    when "experience_point_award"
      "You got #{self.source.amount} #{self.source.award_type} points!"
    when "fruit_ticket_gift"
      "#{self.source.from_user.username} sent you Ƒ#{self.source.amount} fruit tickets!"
    when "supporter_fruit_ticket_stipend"
      "You got Ƒ#{self.source.amount} fruit tickets for supporting datafruits. The bank of fruit tickets thanks you for your support!"
    when "track_playback_ticket_payment"
      "You got Ƒ#{self.source.amount} fruit tickets for your contributions!"
    when "glorp_lottery_winner"
      ":#{self.source.award_type.split("py").first}:!!! #{self.user.username} got #{self.source.amount} #{self.source.award_type} points!"
    when "show_comment"
      "#{self.source.title} has a new comment!"
    when "patreon_sub"
      gif_url = GiphyTextAnimator.animate_text self.source.name
      name = self.source.user&.username || self.source.name
      if gif_url.is_a? String
        "#{name} subscribed to the #{self.source.tier_name} tier on patreon! #{gif_url} #{self.source.patreon_checkout_link}"
      else
        "#{name} subscribed to the #{self.source.tier_name} tier on patreon! #{self.source.patreon_checkout_link}"
      end
    when "new_thread"
      "New thread posted in da fruit standz: #{self.source.title}"
    when "new_thread_reply"
      "New reply to thread #{self.source.title}"
    when "new_wiki_page"
      "New wiki page created: #{self.source.title}"
    when "wiki_page_update"
      "wiki page #{self.source.wiki_page.title} was updated!"
    when "new_datafruiter"
      "new datafruiter on the loose, #{self.source.username} joined!"
    when "profile_update"
      "#{self.source.username}'s bio was updated!"
    when "avatar_update"
      "#{self.source.username}'s fruitification emblem was updated: #{self.source.image.url(:thumb)}"
    when "new_podcast"
      "New archive published: #{self.source.title}"
    when "shrimpo_started"
      "#{self.source.title} shrimpo started!!!!!"
    when "shrimpo_entry"
      "#{self.source.shrimpo.emoji} Someone shrimpoed for #{self.source.shrimpo.title} ! There are #{self.source.shrimpo.shrimpo_entries.count} total entries now."
    when "shrimpo_voting_started"
      "#{self.source.title} shrimpo ended! Time to vote!"
    when "shrimpo_comment"
      "#{self.source.title} has a new comment!"
    when "shrimpo_entry_comment"
      "#{self.source.title} has a new comment!"
    when "fruit_ticket_stimulus"
      "You received a stimulus from the bank of fruit tix: Ƒ#{self.source.amount}"
    when "treasure_fruit_tix_reward"
      "You found Ƒ#{self.source.amount} in a treasure chest!"
    when "shrimpo_deposit_return"
      "Your shrimpo deposit was returned for Ƒ#{self.source.amount}"
    end
  end

  def send_notification
    if self.send_to_chat?
      if self.url.present?
        msg = "#{self.message} - #{self.url}"
      else
        msg = self.message
      end
      redis.publish "datafruits:user_notifications", msg
    end
  end
end
