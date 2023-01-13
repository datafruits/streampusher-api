class Api::ForumThreadsController < ApprovalsController
  def index
    forum_threads = ForumThread.all

    render json: forum_threads
  end

  def create
    forum_thread = ForumThread.new forum_thread_params
    authorize! :create, ForumThread
    if forum_thread.save
      render json: forum_thread
    else
      render json: { errors: forum_thread.errors }, status: 422
    end
  end

  def show
    forum_thread = ForumThread.find params[:id]

    render json: forum_thread
  end

  private
  def forum_thread_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [
      :title
    ])
  end
end
