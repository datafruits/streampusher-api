class BlogPostsController < ApplicationController
  before_action :current_radio_required

  def index
    @blog_posts = @current_radio.blog_posts.includes(:blog_post_bodies)

    render json: @blog_posts
  end

  def create
    authorize! :create, BlogPost
    @blog_post = @current_radio.blog_posts.new user: current_user
    if @blog_post.save
      render json: @blog_post
    else
      render json: @blog_post.errors
    end
  end

  def show
    @blog_posts = @current_radio.blog_posts.includes(:blog_post_bodies).find(params[:id])

    render json: @blog_posts
  end

  def update
    authorize! :create, BlogPost
  end
end
