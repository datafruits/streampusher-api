class HostApplicationVote < ApplicationRecord
  belongs_to :host_application
  belongs_to :user
end
