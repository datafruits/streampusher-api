class DjWithRelationshipsSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio, :image_thumb_url, :image_medium_url, :tracks
  has_many :links, embed: :ids, embed_in_root: true, each_serializer: LinkSerializer
  has_many :scheduled_shows, embed: :ids, key: :scheduled_shows, embed_in_root: true, each_serializer: ScheduledShowSerializer

  # tracks are already loaded via scheduled_shows, so we just need the ids here
  def tracks
    object.tracks.pluck :id
  end

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
end
