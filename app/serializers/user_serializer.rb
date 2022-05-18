class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :time_zone, :role, :avatar_url, :style, :avatar, :avatar_filename, :pronouns, :track_favorites
  has_many :track_favorites
  has_many :social_identities

  def avatar_url
    if object.image.present?
      object.image.url(:thumb)
    end
  end

  def avatar
    if object.image.present?
      {
        basename: object.image_file_name,
        attachment: "avatars",
        updated_at: object.image.updated_at
      }
    end
  end

  def avatar_filename
    if object.image.present?
      object.image_file_name
    end
  end
end
