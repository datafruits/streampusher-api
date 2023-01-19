class Api::ForumThreadsController < ApplicationController
  def index
    forum_threads = ForumThread.all

    render json: forum_threads
  end

  def create
    forum_thread = ForumThread.new
    authorize! :create, ForumThread
    if forum_thread.save_new_thread! current_user, forum_thread_params[:title], forum_thread_params[:body]
      ActiveSupport::Notifications.instrument 'forum_thread.created', current_user: current_user.email, forum_thread: forum_thread.title
      render json: forum_thread, include: 'posts'
    else
      render json: { errors: forum_thread.errors }, status: 422
    end
  end

  def show
    forum_thread = ForumThread.friendly.find(params[:id].downcase.gsub(" ", "-").gsub(/[^0-9a-z-]/i, ''))

    render json: forum_thread, include: 'posts'
  end

  private
  def forum_thread_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title, :body
    ])
  end
end
