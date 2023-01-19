class Api::PostsController < ApplicationController
  def create
    authorize! :create, ForumThread

    if !Post::VALID_POSTABLE_TYPES.include?(post_params[:postable_type])
      raise "invalid postable type"
    end

    post = Post.new post_params
    post.user = current_user

    if post.save
      ActiveSupport::Notifications.instrument 'post.created', current_user: current_user.email, post: post.body
      render json: post
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  private
  def post_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :body, :postable_type, :postable_id
    ])
  end
end
