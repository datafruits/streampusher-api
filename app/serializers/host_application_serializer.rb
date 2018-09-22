class HostApplicationSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :link, :desired_time, :interval, :other_comment
end
