class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::Cookies

  before_action :current_radio
  around_action :set_time_zone

  def next
    render json: NextTrack.perform(@current_radio)
  end

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      render json: { error: "forbidden" }, status: 403
    else
      store_location_for :user, request.path
      redirect_to new_user_session_path, :notice => "You need to login first!"
    end
  end

  def respond_with_errors(resource)
    render json: resource, status: :unprocessable_entity, adapter: :json_api,
      serializer: ActiveModel::Serializer::ErrorSerializer
  end

  protected
  def current_radio_required
    raise ActiveRecord::RecordNotFound unless @current_radio
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
    # this code can be adjusted depending on what you are working on in development
    # but usually you just want the first record in the database
    if ::Rails.env.development?
      @current_radio = Radio.first
    else
      if !request.subdomain.blank?
        @current_radio ||= Radio.where("lower(container_name) = ?", request.subdomain.downcase).first
      end
      unless @current_radio.present?
        if user_signed_in?
          @current_radio ||= current_user.radios.first
        end
      end
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, @current_radio, params[:format])
  end
end
