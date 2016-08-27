class MixcloudUploadsController < ApplicationController
  def create
    # if current_user.connected_identity? "mixcloud"
    mixcloud_token = current_user.social_identities.find_by!(provider: "mixcloud").token
    if UploadTrackToMixcloudWorker.perform_later(track.id, mixcloud_token)
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
