class DjWithRelationshipsSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio, :image_thumb_url, :image_medium_url, :style, :tracks, :pronouns, :homepage
  has_many :scheduled_shows, embed: :ids, key: :scheduled_shows, embed_in_root: true, each_serializer: ScheduledShowSerializer

  def scheduled_shows
    object.scheduled_shows.page(scope[:scheduled_shows][:page])
  end

  def meta
    {
      page: scope[:scheduled_shows][:page],
      total_pages: scheduled_shows.page.total_pages.to_i
    }
  end

  # tracks are already loaded via scheduled_shows, so we just need the ids here
  def tracks
    object.tracks.order("tracks.created_at DESC").pluck :id
  end

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
end
