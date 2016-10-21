require_relative '../../lib/docker_wrapper'

class Radio < ActiveRecord::Base
  has_many :user_radios
  has_many :users, through: :user_radios
  has_many :scheduled_shows
  has_many :tracks
  has_many :playlists
  has_many :podcasts
  has_many :recordings
  has_many :listens
  belongs_to :subscription
  belongs_to :default_playlist, class_name: "Playlist"
  after_create :create_default_playlist

  validates :name, presence: true
  # validates :name, format: { with: /\A[a-zA-Z0-9_]+\z/ }
  validates :name, uniqueness: true
  before_validation :fix_spaces_in_radio_name

  scope :enabled, -> { where(enabled: true) }

  def djs
    self.users
  end

  def boot_radio
    RadioBooterWorker.perform_later self.id
  end

  def disable_radio
    RadioDisableWorker.perform_later self.id
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
      dir = "/tmp/#{self.name}".to_s
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

  def liquidsoap_harbor_port
    Redis.current.hget "proxy-domain", liquidsoap_proxy_key
  end

  def current_scheduled_show now=Time.now
    self.scheduled_shows.where("start_at <= ? AND end_at >= ?", now, now).first
  end

  def next_scheduled_show now=Time.now
    self.scheduled_shows.where("start_at >= ?", now).order("start_at ASC").first
  end

  def disk_usage
    self.tracks.pluck(:filesize).sum
  end

  def liquidsoap_socket_path
    "#{tracks_directory}/liquidsoap.sock"
  end

  private
  def fix_spaces_in_radio_name
    if self.name.present?
      self.name = self.name.gsub(/\s/, "_")
    end
  end

  def create_default_playlist
    self.playlists.create name: "default"
  end
end
