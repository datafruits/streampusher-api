class ChatMessagesController < ApplicationController
  def index
    subscriber = chat_redis_connection

    datastar.on_client_disconnect do
      subscriber.close
    end

    datastar.stream(heartbeat: 15) do |sse|
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
    body = params.dig(:chat, :body).to_s.strip

    if body.blank?
      datastar.patch_signals(
        chat: { error: "Message cannot be blank" }
      )
      return
    end

    message = {
      id: SecureRandom.uuid,
      user: current_user.username,
      body: body,
      timestamp: Time.current.iso8601,
      role: current_user.role,
      avatar_url: current_user.avatar_url
    }

    StreamPusher.redis.publish(
      "datafruits:chat:messages",
      JSON.generate(message)
    )

    datastar.patch_signals(
      chat: {
        body: "",
        error: nil
      }
    )

  end

  private

  def chat_redis_connection
    Redis.new(
      host: ENV.fetch("REDIS_HOST", "redis"),
      port: ENV.fetch("REDIS_PORT", 6379),
      password: ENV["REDIS_PASSWORD"]
    )
  end
end
