class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :time_zone, :role, :avatar_url, :style
  has_many :social_identities

  def avatar_url
    if object.image.present?
      object.image.url(:thumb)
    end
  end
end
