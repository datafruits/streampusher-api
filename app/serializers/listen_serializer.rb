class ListenSerializer < ActiveModel::Serializer
  attributes :start_at, :end_at, :lat, :lon
end
