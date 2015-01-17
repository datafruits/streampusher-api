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
    RadioBooterWorker.perform_async self.id
  end

  def icecast_container
    if !self.icecast_container_id.blank?
      begin
        Docker::Container.get self.icecast_container_id
      rescue
        nil
      end
    end
  end

  def icecast_panel_url
    "http://#{self.virtual_host}:8000/"
  end

  def mp3_url
    "#{self.icecast_panel_url}#{self.name}.mp3"
  end

  def liquidsoap_container
    if !self.liquidsoap_container_id.blank?
      begin
        Docker::Container.get self.liquidsoap_container_id
      rescue
        nil
      end
    end
  end
end
