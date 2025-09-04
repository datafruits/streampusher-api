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
    :dragionfruit_badge_award,
    :blueberrinies_badge_award,
    :beamsprout_badge_award,
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
    case self.notification_type
    when "strawberry_badge_award"
      set_translation_key("notifications.badge_award.strawberry", { username: self.user.username })
    when "lemon_badge_award"
      set_translation_key("notifications.badge_award.lemon", { username: self.user.username })
    when "orange_badge_award"
      set_translation_key("notifications.badge_award.orange", { username: self.user.username })
    when "banana_badge_award"
      set_translation_key("notifications.badge_award.banana", { username: self.user.username })
    when "cabbage_badge_award"
      set_translation_key("notifications.badge_award.cabbage", { username: self.user.username })
    when "watermelon_badge_award"
      set_translation_key("notifications.badge_award.watermelon", { username: self.user.username })
    when "pineapple_badge_award"
      set_translation_key("notifications.badge_award.pineapple", { username: self.user.username })
    when "limer_badge_award"
      set_translation_key("notifications.badge_award.limer", { username: self.user.username })
    when "dragionfruit_badge_award"
      set_translation_key("notifications.badge_award.dragionfruit", { username: self.user.username })
    when "blueberrinies_badge_award"
      set_translation_key("notifications.badge_award.blueberrinies", { username: self.user.username })
    when "beamsprout_badge_award"
      set_translation_key("notifications.badge_award.beamsprout", { username: self.user.username })
    when "dj_badge_award"
      set_translation_key("notifications.badge_award.dj", { username: self.user.username })
    when "vj_badge_award"
      set_translation_key("notifications.badge_award.vj", { username: self.user.username })
    when "supporter_badge_award"
      set_translation_key("notifications.badge_award.supporter", { username: self.user.username })
    when "gold_supporter_badge_award"
      set_translation_key("notifications.badge_award.gold_supporter", { username: self.user.username })
    when "emerald_supporter_badge_award"
      set_translation_key("notifications.badge_award.emerald_supporter", { username: self.user.username })
    when "duckle_badge_award"
      set_translation_key("notifications.badge_award.duckle", { username: self.user.username })
    when "level_up"
      set_translation_key("notifications.level_up", { username: self.user.username, level: self.user.level })
    when "experience_point_award"
      set_translation_key("notifications.experience_point_award", { amount: self.source.amount, award_type: self.source.award_type })
    when "fruit_ticket_gift"
      set_translation_key("notifications.fruit_ticket_gift", { from_username: self.source.from_user.username, amount: self.source.amount })
    when "supporter_fruit_ticket_stipend"
      set_translation_key("notifications.supporter_fruit_ticket_stipend", { amount: self.source.amount })
    when "track_playback_ticket_payment"
      set_translation_key("notifications.track_playback_ticket_payment", { amount: self.source.amount })
    when "glorp_lottery_winner"
      award_emoji = self.source.award_type.split("py").first
      set_translation_key("notifications.glorp_lottery_winner", { 
        username: self.user.username, 
        amount: self.source.amount, 
        award_type: self.source.award_type,
        award_emoji: award_emoji
      })
    when "show_comment"
      set_translation_key("notifications.show_comment", { title: self.source.title })
    when "patreon_sub"
      gif_url = GiphyTextAnimator.animate_text self.source.name
      params = { 
        name: self.source.name, 
        tier_name: self.source.tier_name, 
        patreon_checkout_link: self.source.patreon_checkout_link
      }
      if gif_url.is_a? String
        params[:gif_url] = gif_url
        set_translation_key("notifications.patreon_sub.with_gif", params)
      else
        set_translation_key("notifications.patreon_sub.without_gif", params)
      end
    when "new_thread"
      set_translation_key("notifications.new_thread", { title: self.source.title })
    when "new_thread_reply"
      set_translation_key("notifications.new_thread_reply", { title: self.source.title })
    when "new_wiki_page"
      set_translation_key("notifications.new_wiki_page", { title: self.source.title })
    when "wiki_page_update"
      set_translation_key("notifications.wiki_page_update", { title: self.source.title })
    when "new_datafruiter"
      set_translation_key("notifications.new_datafruiter", { username: self.source.username })
    when "profile_update"
      set_translation_key("notifications.profile_update", { username: self.source.username })
    when "avatar_update"
      set_translation_key("notifications.avatar_update", { 
        username: self.source.username, 
        image_url: self.source.image.url(:thumb)
      })
    when "new_podcast"
      set_translation_key("notifications.new_podcast", { title: self.source.title })
    when "shrimpo_started"
      set_translation_key("notifications.shrimpo_started", { title: self.source.title })
    when "shrimpo_entry"
      set_translation_key("notifications.shrimpo_entry", { 
        emoji: self.source.shrimpo.emoji, 
        title: self.source.shrimpo.title, 
        entry_count: self.source.shrimpo.shrimpo_entries.count
      })
    when "shrimpo_voting_started"
      set_translation_key("notifications.shrimpo_voting_started", { title: self.source.title })
    when "shrimpo_comment"
      set_translation_key("notifications.shrimpo_comment", { title: self.source.title })
    when "shrimpo_entry_comment"
      set_translation_key("notifications.shrimpo_entry_comment", { title: self.source.title })
    when "fruit_ticket_stimulus"
      set_translation_key("notifications.fruit_ticket_stimulus", { amount: self.source.amount })
    when "treasure_fruit_tix_reward"
      set_translation_key("notifications.treasure_fruit_tix_reward", { amount: self.source.amount })
    when "shrimpo_deposit_return"
      set_translation_key("notifications.shrimpo_deposit_return", { amount: self.source.amount })
    end
  end

  def set_translation_key(key, params = {})
    self.message_key = key
    self.message_params = params
    # Keep the message field for backward compatibility, but it will be empty for new notifications
    self.message = ""
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
