class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :message, :read, :url
end
