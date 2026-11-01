class ChatMessagesController < ApplicationController
  prepend_around_action :record_chat_timings, only: :create
  around_action :record_chat_action_timing, only: :create

  def index
    subscriber = chat_redis_connection

    datastar.on_client_disconnect do
      subscriber.close
    end

    datastar.stream(heartbeat: 5) do |sse|
      subscriber.subscribe("datafruits:chat:messages") do |events|
        events.message do |_channel, payload|
          message = JSON.parse(payload, symbolize_names: true)

          html = ApplicationController.render(
            partial: "chat/message",
            locals: { message: message }
          )

          sse.patch_elements(
            html,
            selector: "#messages",
            mode: "append",
            id: message.fetch(:id)
          )
        end
      end
    ensure
      subscriber.close
    end
  end

  def create
    user = measure_chat_step(:identity) { current_user }
    username = user&.username || session[:chat_nickname]
    if username.blank?
      datastar.patch_signals(chat: { joined: false, error: t("chat.errors.join_required") })
      return
    end

    body = params.dig(:chat, :body).to_s.strip

    if body.blank?
      datastar.patch_signals(
        chat: { error: "Message cannot be blank" }
      )
      return
    end

    message = {
      id: SecureRandom.uuid,
      user: username,
      body: body,
      timestamp: Time.current.iso8601,
      role: user&.role,
      avatar_url: measure_chat_step(:avatar) { chat_avatar_url(user) }
    }

    payload = JSON.generate(message)
    measure_chat_step(:redis_publish) do
      StreamPusher.redis.publish("datafruits:chat:messages", payload)
    end

    measure_chat_step(:response_setup) do
      datastar.patch_signals(
        chat: {
          body: "",
          error: nil
        }
      )
    end

  end

  private

  def verify_authenticity_token
    return super unless @chat_timings

    measure_chat_step(:csrf) { super }
  end

  def current_radio
    return super unless @chat_timings

    measure_chat_step(:radio_lookup) { super }
  end

  def merge_datastar_signals
    return super unless @chat_timings

    measure_chat_step(:signals_setup) { super }
  end

  def chat_avatar_url(user)
    avatar = user&.as_image
    return unless avatar&.attached?

    # Resolve the storage URL when the browser loads the image, keeping S3
    # client initialization and credential lookup out of message publishing.
    rails_blob_path(avatar, only_path: true)
  end

  def record_chat_timings
    @chat_timings = {}
    measure_chat_step(:controller) { yield }
  ensure
    timings = @chat_timings.map { |name, duration| "chat_#{name};dur=#{duration}" }.join(", ")
    response.headers["Server-Timing"] = [response.headers["Server-Timing"], timings].compact.join(", ")
  end

  def record_chat_action_timing
    measure_chat_step(:action) { yield }
  end

  def measure_chat_step(name)
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
  ensure
    @chat_timings[name] = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started) * 1000).round(2)
  end

  def append_info_to_payload(payload)
    super
    # Lograge includes custom_payload in the existing request log line.
    payload[:custom_payload] = (payload[:custom_payload] || {}).merge(
      (@chat_timings || {}).transform_keys { |name| :"chat_#{name}_ms" }
    )
  end

  def chat_redis_connection
    Redis.new(
      host: ENV.fetch("REDIS_HOST", "redis"),
      port: ENV.fetch("REDIS_PORT", 6379),
      password: ENV["REDIS_PASSWORD"]
    )
  end
end
