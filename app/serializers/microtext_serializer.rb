class MicrotextSerializer < ActiveModel::Serializer
  attributes :content, :id, :username

  def username
    object.user.username
  end
end
