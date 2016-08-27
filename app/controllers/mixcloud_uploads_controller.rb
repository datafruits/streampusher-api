class MixcloudUploadsController < ApplicationController
  def create
    # if current_user.connected_identity? "mixcloud"
    mixcloud_token = current_user.social_identities.find_by!(provider: "mixcloud").token
    respond_to do |format|
      if UploadTrackToMixcloudWorker.perform_later(track.id, mixcloud_token)
        format.json { head :ok }
      else
        format.json { render :json => "error", :status => :unprocessable_entity }
      end
    end
  end

  private
  def track
    @current_radio.tracks.find(params[:track_id])
  end
end
