class ForumThreadsController < ApplicationController
  def index
    @forum_threads = ForumThread.includes(posts: :user).order(updated_at: :desc)
  end

  def show
    @forum_thread = ForumThread.friendly.includes(posts: :user).find(params[:id])
  end

  def create
    authorize! :create, ForumThread

    @forum_thread = ForumThread.new
    @forum_thread.save_new_thread!(current_user, forum_thread_params[:title], forum_thread_params[:body])

    ActiveSupport::Notifications.instrument(
      "forum_thread.created",
      username: current_user.username,
      forum_thread: @forum_thread.title,
      slug: @forum_thread.slug
    )

    datastar.redirect(forum_thread_path(@forum_thread))
  rescue ActiveRecord::RecordInvalid => error
    datastar.patch_signals(forum: { error: error.record.errors.full_messages.to_sentence })
  end

  private

  def forum_thread_params
    params.require(:forum).permit(:title, :body)
  end
end
