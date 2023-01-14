class Api::ForumThreadsController < ApprovalsController
  load_and_authorize_resource except: [:index, :show]

  def index
    forum_threads = ForumThread.all

    render json: forum_threads
  end

  def create
    forum_thread = ForumThread.new
    authorize! :create, ForumThread
    if forum_thread.save_new_thread! current_user, forum_thread_params[:title], forum_thread_params[:body]
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
      :title, :body
    ])
  end
end
