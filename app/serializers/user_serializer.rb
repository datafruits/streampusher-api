class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :time_zone, :role, :avatar_url, :style, :avatar_filename, :pronouns, :track_favorites, :fruits_affinity, :bio
  has_many :track_favorites
  has_many :social_identities

  def avatar_url
    if object.image.present?
      object.image.url(:thumb)
    end
  end

  def avatar_filename
    if object.image.present?
      object.image_file_name
    end
  end

  def fruits_affinity
    Redis.current.hgetall "datafruits:user_fruit_count:#{object.username}"
  end
end
