class HostApplicationSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :link, :homepage_url, :desired_time, :interval, :other_comment, :approved, :created_at
end
