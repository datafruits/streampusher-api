class OnboardingMailer < ApplicationMailer
  def playlists user
    @user = user
    mail subject: "Get started with Streampusher playlists", to: @user.email
  end

  def stats user
    @user = user
    mail subject: "Know your audience with Streampusher stats", to: @user.email
  end

  def djs user
    @user = user
    mail subject: "Assign other DJs to your station", to: @user.email
  end

  def broadcasting user
    @user = user
    @current_radio = @user.radios.first
    mail subject: "Have you broadcasted live yet?", to: @user.email
  end
end
