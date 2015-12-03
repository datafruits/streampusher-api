class Label < ActiveRecord::Base
  validates :name, presence: true
end
