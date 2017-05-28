class DjSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar, :bio
end
