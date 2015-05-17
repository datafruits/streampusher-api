class ScheduledShowSerializer < ActiveModel::Serializer
  attributes :id, :start, :end, :title
end
