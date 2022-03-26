class UserFollowSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :followee_id, :followee_name

  def followee_name
    object.followee.username
  end
end
