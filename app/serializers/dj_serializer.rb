class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio, :image, :style, :email,
    :image_thumb_url, :image_medium_url, :profile_publish, :pronouns, :role, :fruits_affinity,
    :homepage, :fruit_ticket_balance, :created_at, :last_sign_in_at,
    :level, :experience_points, :xp_needed_for_next_level

  def image_url
    if object.image.present?
      object.image.url
    end
  end

  def image_thumb_url
    if object.image.present?
      object.image.url(:thumb)
    end
  end

  def image_medium_url
    if object.image.present?
      object.image.url(:medium)
    end
  end

  def fruits_affinity
    StreamPusher.redis.hgetall "datafruits:user_fruit_count:#{object.username}"
  end
end
