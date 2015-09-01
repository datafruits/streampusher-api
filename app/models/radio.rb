class Radio < ActiveRecord::Base
  after_create :boot_radio
  has_many :user_radios
  has_many :users, through: :user_radios
  has_many :shows
  has_many :scheduled_shows
  has_many :tracks
  has_many :playlists
  has_many :podcasts
  belongs_to :subscription
  belongs_to :default_playlist, class_name: "Playlist"

  def djs
    self.users
  end

  def boot_radio
    RadioBooterWorker.perform_later self.id
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

  def icecast_json
    "#{icecast_panel_url}status-json.xsl"
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

  def virtual_host
    "#{self.name}.streampusher.com"
  end

  def tracks_directory
    if ::Rails.env.production?
      dir = "/home/deploy/#{self.name}"
    else
      dir = ::Rails.root.join("tmp/#{self.name}").to_s
    end
    FileUtils.mkdir_p dir
    dir
  end

  def icecast_proxy_key
    "#{self.virtual_host}/icecast"
  end

  def liquidsoap_proxy_key
    "#{self.virtual_host}/liquidsoap"
  end

  def default_playlist_key
    "#{self.name}:default_playlist"
  end
end
