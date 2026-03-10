class LandingController < HtmlController
  layout "hotwire"

  before_action :save_referer

  def index
    @current_show = fetch_current_show
    @april_fools = april_fools?
    @site_settings = {}
  end

  private

  def save_referer
    session['referer'] = request.env["HTTP_REFERER"]
  end

  def fetch_current_show
    ScheduledShow.current.first
  rescue StandardError
    nil
  end

  def april_fools?
    today = Time.zone.today
    today.month == 4 && today.day == 1
  end
end
