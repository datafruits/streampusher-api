class Radio < ActiveRecord::Base
  after_create :boot_radio
  has_many :user_radios
  has_many :users, through: :user_radios
  has_many :shows
  has_many :tracks
  has_many :playlists
  belongs_to :subscription

  def djs
    self.users
  end

  def boot_radio
    RadioBooter.perform_async self.id
  end

  def container
    Docker::Container.get self.docker_container_id
  end
end
