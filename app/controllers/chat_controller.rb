class ChatController < ApplicationController
  MAX_NICKNAME_LENGTH = 30

  def index
  end

  def join
    unless user_signed_in?
      nickname = params.dig(:chat, :nickname).to_s.strip
      error = if nickname.blank?
        t("chat.errors.nickname_required")
      elsif nickname.length > MAX_NICKNAME_LENGTH
        t("chat.errors.nickname_too_long", count: MAX_NICKNAME_LENGTH)
      elsif nickname.match?(/[[:cntrl:]]/)
        t("chat.errors.nickname_invalid")
      elsif User.where("lower(username) = ?", nickname.downcase).exists?
        t("chat.errors.nickname_registered")
      end

      if error
        datastar.patch_signals(chat: { error: error })
        return
      end

      session[:chat_nickname] = nickname
    end

    datastar.patch_signals(chat: { joined: true, error: nil })
  end
end
