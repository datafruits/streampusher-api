class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :message, :message_key, :message_params, :read, :url
end
