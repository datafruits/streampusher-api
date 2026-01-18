class ScheduledShowSerializer < ActiveModel::Serializer
  attributes :id, :start, :end, :title, :image_url, :thumb_image_url, :description,
    :slug, :recurring_interval, :hosted_by, :is_guest, :guest, :playlist_id, :image_filename, :formatted_episode_title, :status,
    :show_series_title, :show_series_slug, :hosts,
    :prerecord_track_id,
    :prerecord_track_filename,
    :youtube_link,
    :mixcloud_link,
    :soundcloud_link

  has_many :tracks, embed: :ids, key: :tracks
  has_many :djs, embed: :ids, key: :djs, embed_in_root: true, each_serializer: DjSerializer
  has_many :posts, embed: :ids, key: :posts, embed_in_root: true, each_serializer: PostSerializer
  has_many :labels, embed: :ids, key: :labels, embed_in_root: true

  def labels
    object.labels
  end

  def prerecord_track_filename
    if object.prerecord_track_id.present?
      Track.find(object.prerecord_track_id).audio_file_name
    end
  end

  def show_series_slug
    if object.show_series.present?
      object.show_series.slug
    end
  end

  def show_series_title
    if object.show_series.present?
      object.show_series.title
    end
  end

  def posts
    object.posts
  end

  def formatted_episode_title
    object.formatted_episode_title
  end

  def hosted_by
    if object.performers.any?
      object.performers.first.username
    end
  end

  def hosts
    if object.performers.any?
      object.performers.pluck :username
    end
  end

  def djs
    object.performers
  end

  def tracks
    # don't show tracks if the show isn't over yet...
    if Time.now > object.end_at
      return object.tracks
    else
      return []
    end
  end

  def image_url
    if object.image.present?
      CGI.unescape(object.image_url)
    end
  end

  def thumb_image_url
    if object.image.present?
      CGI.unescape(object.thumb_image_url)
    end
  end

  def image_filename
    if object.image.present?
      object.image_file_name
    end
  end

  def as_image
    if object.as_image.present?
      if ::Rails.env != "production"
        path = ::Rails.application.routes.url_helpers.rails_blob_path(object.as_image, only_path: true, disposition: 'attachment')
        "http://localhost:3000#{path}"
      else
        object.as_image.url
      end
    end
  end
end
