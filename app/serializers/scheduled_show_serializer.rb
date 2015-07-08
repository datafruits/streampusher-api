class ScheduledShowSerializer < ActiveModel::Serializer
  attributes :id, :start, :end, :title, :image_url

end
