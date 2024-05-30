class ShowSeriesLabel < ApplicationRecord
  belongs_to :label
  belongs_to :show_series
end
