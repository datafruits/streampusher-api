class PodcastsController < ApplicationController
  load_and_authorize_resource except: [:show]
  def index
    @podcasts = @current_radio.podcasts
    @podcast = Podcast.new
  end

  def create
    if @podcast.save
      redirect_to podcasts_path
    else
      @podcasts = @current_radio.podcasts
      render 'index'
    end
  end

  def edit
    @podcast = @current_radio.podcasts.find params[:id]
  end

  def update
    @podcast.attributes = podcast_params
    if @podcast.save
      redirect_to podcasts_path
    else
      @podcasts = @current_radio.podcasts
      render 'index'
    end
  end

  def show
    @podcast = @current_radio.podcasts.find_by_name(params[:id])
    respond_to do |format|
      format.xml { render 'show', layout: false }
    end
  end

  private
  def podcast_params
    params.require(:podcast).permit(:name, :playlist_id, :radio_id, :image)
  end
end
