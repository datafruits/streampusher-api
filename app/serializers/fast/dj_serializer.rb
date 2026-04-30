class Fast::DjSerializer
  include JSONAPI::Serializer

  attributes :id, :username, :image_url, :bio, :image, :style,
    :image_thumb_url, :profile_publish, :pronouns, :role,
    :homepage, :fruit_ticket_balance, :created_at, :last_sign_in_at,
    :level, :experience_points, :xp_needed_for_next_level, :avatar_url

  attribute :avatar_url do |object|
    object.image_url
  end

  attribute :image_url do |object|
    object.image_url
  end

  attribute :image_thumb_url do |object|
    object.thumb_image_url
  end
end
