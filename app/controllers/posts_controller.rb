class PostsController < ApplicationController
  def create
    authorize! :create, ForumThread

    @forum_thread = ForumThread.friendly.find(params[:forum_thread_id])
    @post = @forum_thread.posts.build(post_params.merge(user: current_user))

    if @post.save
      ActiveSupport::Notifications.instrument(
        "post.created",
        username: current_user.username,
        post: "#{@post.body.first(15)}...",
        postable_type: "ForumThread",
        slug: @forum_thread.slug
      )

      datastar.stream do |sse|
        sse.patch_elements(
          render_to_string(partial: "forum_threads/post", locals: { post: @post }),
          selector: "#forum-posts",
          mode: "append"
        )
        sse.patch_signals(reply: { body: "", error: nil })
      end
    else
      datastar.patch_signals(reply: { error: @post.errors.full_messages.to_sentence })
    end
  end

  private

  def post_params
    params.require(:reply).permit(:body)
  end
end
