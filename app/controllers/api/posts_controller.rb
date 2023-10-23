class Api::PostsController < ApplicationController
  def create
    authorize! :create, ForumThread

    if !Post::VALID_POSTABLE_TYPES.include?(post_params[:postable_type])
      raise "invalid postable type"
    end

    post = Post.new post_params
    post.user = current_user

    if post.save
      payload = { username: current_user.username, post: post.body.first(15)+"...", postable_type: post.postable_type, slug: post.postable.slug }
      if post_params[:postable_type] === 'ScheduledShow'
        payload[:show_series_slug] = post.postable.show_series.slug
      end
      ActiveSupport::Notifications.instrument 'post.created', payload
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
