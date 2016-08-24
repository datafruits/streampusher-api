class MixcloudUploadsController < ApplicationController
  def create
    # if current_user.connected_identity? "mixcloud"
    mixcloud_token = current_user.social_identities.find_by!(provider: "mixcloud").token
    UploadTrackToMixcloudWorker.perform_later track.id, mixcloud_token
  end

  private
  def track
    @current_radio.tracks.find(params[:track_id])
  end
end
