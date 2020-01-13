class Api::BlogPostsController < ApplicationController
  before_action :current_radio_required

  def index
    @blog_posts = @current_radio.blog_posts.published.includes(:blog_post_bodies)

    render json: @blog_posts
  end

  def show
    @blog_post = @current_radio.blog_posts.published.includes(:blog_post_bodies).find(params[:id])

    render json: @blog_post
  end
end
