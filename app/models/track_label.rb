class TrackLabel < ActiveRecord::Base
  belongs_to :label
  belongs_to :tag
end
