class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio
  has_many :links, embed: :ids, embed_in_root: true, each_serializer: LinkSerializer
  has_many :tracks, embed: :ids, key: :tracks, embed_in_root: true, each_serializer: TrackSerializer
  has_many :scheduled_shows, embed: :ids, key: :upcoming_shows, embed_in_root: true, each_serializer: ScheduledShowSerializer
  def scheduled_shows
    ScheduledShow.where(id: ScheduledShowPerformer.where(user_id: object.id)
      .pluck(:scheduled_show_id)).where("start_at >= (?)", Time.now)
  end

  def image_url
    if object.image.present?
      object.image.url
    end
  end

  def tracks
    track_ids = ScheduledShow.find(ScheduledShowPerformer.where(user_id: object.id)
      .pluck(:scheduled_show_id)).map(&:track_ids).flatten
    if track_ids.any?
      Track.find(track_ids) #.order("created_at DESC")
    else
      []
    end
  end
end
