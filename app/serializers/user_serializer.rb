class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :time_zone, :role
  has_many :social_identities
end
