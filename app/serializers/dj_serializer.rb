class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :image_url, :bio

  def image_url
    if object.image.present?
      object.image.url
    end
  end

  def podcasts
    Track.find(ScheduledShow.find(ScheduledShowPerformer.where(user_id: object.id).pluck(:scheduled_show_id)).map(&:track_ids)).order("created_at DESC")
  end
end
