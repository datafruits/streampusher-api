class BlogPostImagesController < ApplicationController
  before_action :current_radio_required

  def create
    authorize! :create, BlogPost
    # FIXME need to check current_radio
    blog_post_body = BlogPostBody.find(blog_post_image_params[:blog_post_body_id])
    @image = blog_post_body.blog_post_images.new blog_post_image_params
    if @image.save
      render json: @image
    else
      render json: @image.errors
    end
  end

  private
  def blog_post_image_params
    params.require(:blog_post_image).permit(:image_file_name, :blog_post_body_id)
  end
end
