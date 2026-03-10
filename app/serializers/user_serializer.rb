class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :time_zone, :role, :avatar_url, :style, :avatar_filename, :pronouns, :scheduled_show_favorites, :fruits_affinity, :bio, :homepage, :fruit_ticket_balance,
    :image_url, :image_file_name,
    :level, :experience_points, :xp_needed_for_next_level,
    :xp_progress_percentage,
    :has_unread_notifications
  has_many :scheduled_show_favorites
  has_many :social_identities

  def has_unread_notifications
    object.notifications.where(read: false).any?
  end

  def avatar_url
    if object.as_image.present?
      if ::Rails.env != "production"
        path = ::Rails.application.routes.url_helpers.rails_blob_path(object.as_image, only_path: true, disposition: 'attachment')
        "http://localhost:3000#{path}"
      else
        object.as_image.url
      end
    end
  end

  def avatar_filename
    if object.image.present?
      object.image_file_name
    end
  end

  def image_url
    if object.as_image.present?
      if ::Rails.env != "production"
        path = ::Rails.application.routes.url_helpers.rails_blob_path(object.as_image, only_path: true, disposition: 'attachment')
        "http://localhost:3000#{path}"
      else
        object.as_image.url
      end
    end
  end

  def image_filename
    if object.image.present?
      object.image_file_name
    end
  end


  def fruits_affinity
    StreamPusher.redis.hgetall "datafruits:user_fruit_count:#{object.username}"
  end
end
