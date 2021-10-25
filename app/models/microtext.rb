class Microtext < ApplicationRecord
  belongs_to :user
  belongs_to :radio
  after_create :archive_in_30_days

  private
  def archive_in_30_days
    ArchiveMicrotextWorker.set(wait: 30.days).perform_later(self.id)
  end
end
