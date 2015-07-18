class ScheduledShowSerializer < ActiveModel::Serializer
  include ScheduledShowsHelper
  attributes :id, :start, :end, :title, :image_url, :dj, :tweet_content

  def tweet_content
    tweet_text(object)
  end
end
