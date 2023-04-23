class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :created_at

  def message
    object.message
  end
end
