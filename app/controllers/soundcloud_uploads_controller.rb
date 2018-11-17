class SoundcloudUploadsController < ApplicationController
  before_action :current_radio_required
  def create
    soundcloud_token = @current_radio.owner.social_identities.find_by!(provider: "soundcloud").token
    if UploadTrackToSoundcloudWorker.perform_later(track.id, soundcloud_token)
      render json: { message: "OK", status: 200 }
    else
      render json: { message: "error", status: :unprocessable_entity }
    end
  end

  private
  def track
    @current_radio.tracks.find(params[:track_id])
  end
end
