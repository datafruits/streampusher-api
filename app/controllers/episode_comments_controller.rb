class EpisodeCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_radio_required

  def create
    show = @current_radio.show_series.where.not(status: :disabled).friendly.find(params[:show_id])
    episode = show.episodes.where(radio_id: @current_radio.id).friendly.find(params[:episode_id])
    post = episode.posts.build(body: params.require(:comment).permit(:body)[:body], user: current_user)

    if post.save
      html = render_to_string(partial: 'forum_threads/post', locals: { post: post })
      datastar.stream do |sse|
        sse.patch_elements(html, selector: '#episode-comments', mode: 'append')
        sse.patch_signals(comment: { body: '', error: nil })
      end
    else
      datastar.patch_signals(comment: { error: post.errors.full_messages.to_sentence })
    end
  end
end
