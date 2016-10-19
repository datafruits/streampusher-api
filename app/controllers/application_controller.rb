class ApplicationController < ActionController::Base
  include ActionController::Serialization
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  after_filter :flash_to_headers
  before_filter :current_radio
  around_filter :set_time_zone

  layout :layout_by_resource

  def next
    render json: NextTrack.perform(@current_radio)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      render :file => "#{Rails.root}/public/403.html", :status => 403
    else
      store_location_for :user, request.path
      redirect_to new_user_session_path, :notice => "You need to login first!"
    end
  end

  protected
  def layout_by_resource
    if (devise_controller? || params["controller"] == "landing") && action_name != "edit"
      "landing"
    else
      "application"
    end
  end

  def redirect_to_with_js(options = {}, response_status = {})
    redirect_to(options,response_status)
    if request.xhr?
      self.status = 200
      self.content_type ||= Mime::JS
      self.response_body = "window.location = '#{location}';"
    end
  end

  def set_time_zone(&block)
    if current_user
      Time.use_zone(current_user.time_zone, &block)
    elsif params["timezone"].present?
      Time.use_zone(params["timezone"], &block)
    elsif browser_timezone.present?
      Time.use_zone(browser_timezone, &block)
    else
      yield
    end
  end

  def browser_timezone
    cookies["browser.timezone"]
  end

  def current_radio
    if !request.subdomain.blank?
      @current_radio ||= Radio.find_by_name request.subdomain
    end
    unless @current_radio.present?
      if user_signed_in?
        @current_radio ||= current_user.radios.first
      end
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, @current_radio, params[:format])
  end

  def flash_to_headers
    return unless request.xhr?
    return if flash.empty?
    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type.to_s

    flash.discard # don't want the flash to appear when you reload page
  end

  def flash_message
    [:error, :warning, :notice].each do |type|
      return flash[type] unless flash[type].blank?
    end
  end

  def flash_type
    [:error, :warning, :notice].each do |type|
      return type unless flash[type].blank?
    end
  end
end
