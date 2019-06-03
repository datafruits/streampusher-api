class ScheduledShowSerializer < ActiveModel::Serializer
  include ScheduledShowsHelper
  include ApplicationHelper
  include ActionView::Helpers::SanitizeHelper
  attributes :id, :start, :end, :title, :image_url, :thumb_image_url, :tweet_content, :description,
    :html_description, :slug

  has_many :tracks, embed: :ids, key: :tracks, embed_in_root: true, each_serializer: TrackSerializer
  has_many :djs, embed: :ids, key: :djs

  def djs
    object.performers
  end

  def tracks
    object.tracks
  end

  def html_description
    html_pipeline(object.description)
  end

  def image_url
    if object.image.present?
      object.image_url
    end
  end

  def thumb_image_url
    if object.image.present?
      object.thumb_image_url
    end
  end

  def tweet_content
    tweet_text(object)
  end
end
