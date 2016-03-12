class ScheduledShowSerializer < ActiveModel::Serializer
  include ScheduledShowsHelper
  attributes :id, :start, :end, :title, :image_url, :thumb_image_url, :dj, :tweet_content, :description

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
