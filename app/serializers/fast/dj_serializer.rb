class Fast::DjSerializer
  include JSONAPI::Serializer

  attributes :id, :username, :image_url, :bio, :image, :style,
    :image_thumb_url, :image_medium_url, :profile_publish, :pronouns, :role,
    :homepage, :fruit_ticket_balance, :created_at, :last_sign_in_at,
    :level, :experience_points, :xp_needed_for_next_level, :avatar_url

  attribute :avatar_url do |object|
    if object.image.present?
      CGI.unescape(object.image.url(:thumb))
    end
  end

  attribute :image_url do |object|
    if object.image.present?
      CGI.unescape(object.image.url)
    end
  end

  attribute :image_thumb_url do |object|
    if object.image.present?
      CGI.unescape(object.image.url(:thumb))
    end
  end

  attribute :image_medium_url do |object|
    if object.image.present?
      CGI.unescape(object.image.url(:medium))
    end
  end
end
