class LandingController < ApplicationController
  before_action :save_referer

  def index
    now = Time.current
    episodes = (@current_radio&.scheduled_shows || ScheduledShow.none).joins(:show_series).
      preload(:labels, as_image_attachment: :blob, show_series: { as_image_attachment: :blob },
              performers: { as_image_attachment: :blob })
    @upcoming = episodes.where(show_series: { status: :active }, start_at: now..now.next_month.end_of_month).
      order(:start_at, :id).limit(3)
    @archives = episodes.archive_published.where.not(show_series: { status: :disabled }).
      where("scheduled_shows.end_at < ?", now).order(start_at: :desc, id: :desc).limit(3)
    @wiki_pages = WikiPage.order(updated_at: :desc, id: :desc).limit(3)
    @threads = ForumThread.order(updated_at: :desc, id: :desc).limit(3).preload(posts: :user)
    @shrimpos = Shrimpo.completed.
      order(Shrimpo.arel_table[:ended_at].desc.nulls_last, id: :desc).
      preload(cover_art_attachment: :blob, user: { as_image_attachment: :blob }).limit(3)
    @entry_counts = ShrimpoEntry.where(shrimpo_id: @shrimpos.map(&:id)).group(:shrimpo_id).count
    @video_id = latest_video_id
  end

  private

  def latest_video_id
    channel = ENV['YOUTUBE_CHANNEL_ID']
    key = ENV['GOOGLE_API_KEY']
    return if channel.blank? || key.blank?

    Rails.cache.fetch(["homepage-youtube", channel], expires_in: 1.hour) do
      response = HTTParty.get("https://www.googleapis.com/youtube/v3/search", timeout: 2,
        query: { channelId: channel, part: "snippet", type: "video", order: "date", maxResults: 1, key: key })
      response.parsed_response.dig("items", 0, "id", "videoId") if response.success?
    rescue HTTParty::Error, IOError, SystemCallError, SocketError, Timeout::Error, OpenSSL::SSL::SSLError, JSON::ParserError
      nil
    end
  end

  def save_referer
    session['referer'] = request.env["HTTP_REFERER"]
  end
end
