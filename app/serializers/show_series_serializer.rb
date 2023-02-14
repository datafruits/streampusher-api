class ShowSeriesSerializer < ActiveModel::Serializer
  attributes :id, :recurring_interval, :recurring_cadence, :recurring_weekday, :title, :description
end
