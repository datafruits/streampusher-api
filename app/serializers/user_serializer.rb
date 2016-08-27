class UserSerializer < ActiveModel::Serializer
  attributes :id, :username
  has_many :social_identities
end
