class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio, :image, :style, :email,
    :image_thumb_url, :image_medium_url, :profile_publish, :pronouns, :role, :fruits_affinity,
    :homepage, :fruit_ticket_balance, :created_at, :last_sign_in_at,
    :level, :experience_points, :xp_needed_for_next_level,
    :trophy_award_counts
  has_many :trophy_awards, embed: :ids, key: :trophy_awards, embed_in_root: true, each_serializer: TrophyAwardSerializer

  def image_url
    if object.image.present?
      CGI.unescape(object.image.url)
    end
  end

  def image_thumb_url
    if object.image.present?
      CGI.unescape(object.image.url(:thumb))
    end
  end

  def image_medium_url
    if object.image.present?
      CGI.unescape(object.image.url(:medium))
    end
  end

  def fruits_affinity
    StreamPusher.redis.hgetall "datafruits:user_fruit_count:#{object.username}"
  end

  def trophy_awards
    object.trophy_awards.joins(:trophy).group('trophies.name').count
  end

  def trophy_award_counts
    object.trophy_awards.group_by
  end
end
