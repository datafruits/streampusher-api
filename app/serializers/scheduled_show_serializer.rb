class ScheduledShowSerializer < ActiveModel::Serializer
  include ScheduledShowsHelper
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper
  attributes :id, :start, :end, :title, :image_url, :thumb_image_url, :tweet_content, :description,
    :slug, :recurring_interval, :hosted_by, :is_guest, :guest, :playlist_id, :image, :image_filename, :formatted_episode_title, :status,
    :show_series_title, :show_series_slug,
    :prerecord_track_id,
    :prerecord_track_filename

  has_many :tracks, embed: :ids, key: :tracks
  has_many :djs, embed: :ids, key: :djs
  belongs_to :playlist
  belongs_to :show_series
  belongs_to :recording
  has_many :posts, embed: :ids, key: :posts, embed_in_root: true, each_serializer: PostSerializer

  def prerecord_track_filename
    Track.find(object.prerecord_track_id).audio_file_name
  end

  def show_series_slug
    object.show_series.slug
  end

  def show_series_title
    object.show_series.title
  end

  def posts
    object.posts
  end

  def formatted_episode_title
    "#{object.title} - #{object.start.strftime("%m%d%Y")}"
  end

  def hosted_by
    if object.performers.any?
      object.performers.first.username
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

  def image
    if object.image.present?
      {
        basename: object.image_file_name,
        attachment: "images",
        updated_at: object.image.updated_at
      }
    end
  end

  def image_filename
    if object.image.present?
      object.image_file_name
    end
  end

  def tweet_content
    tweet_text(object)
  end
end
