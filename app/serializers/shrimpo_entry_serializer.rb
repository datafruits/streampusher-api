class ShrimpoEntrySerializer < ActiveModel::Serializer
  attributes :title, :audio_file_url, :username, :user_avatar, :slug, :user_role, :cdn_url, :shrimpo_emoji, :shrimpo_slug, :created_at, :previous_shrimpo_entry_slug, :next_shrimpo_entry_slug, :total_score, :ranking, :shrimpo_status, :shrimpo_type,
    :shrimpo_title, :shrimpo_total_entries, :shrimpo_voting_completion_percentage
  belongs_to :shrimpo
  has_many :shrimpo_votes, embed: :ids, key: :shrimpo_votes, embed_in_root: true, each_serializer: ShrimpoVoteSerializer
  has_many :posts, embed: :ids, key: :posts, embed_in_root: true, each_serializer: PostSerializer
  has_many :posts, embed: :ids, key: :posts, embed_in_root: true, each_serializer: PostSerializer
  has_many :trophy_awards, embed: :ids, key: :trophy_awards, embed_in_root: true, each_serializer: TrophyAwardSerializer

  def shrimpo_voting_completion_percentage
    object.shrimpo.voting_completion instance_options[:current_user]
  end

  def shrimpo_total_entries
    object.shrimpo.shrimpo_entries.count
  end

  def shrimpo_title
    object.shrimpo.title
  end

  def shrimpo_status
    object.shrimpo.status
  end

  def shrimpo_type
    object.shrimpo.shrimpo_type
  end

  def shrimpo_id
    object.shrimpo.slug
  end

  def previous_shrimpo_entry_slug
    if object.previous_entry.present?
      object.previous_entry.slug
    end
  end

  def next_shrimpo_entry_slug
    if object.next_entry.present?
      object.next_entry.slug
    end
  end

  def shrimpo_slug
    object.shrimpo.slug
  end

  def shrimpo_emoji
    object.shrimpo.emoji
  end

  def audio_file_url
  end

  def cdn_url
    if object.audio.present?
      if ::Rails.env != "production"
        ::Rails.application.routes.url_helpers.rails_blob_path(object.audio, only_path: true, disposition: 'attachment')
      else
        object.audio.url
      end
    end
  end

  def user_role
    object.user.role
  end

  def username
    object.user.username
  end

  def user_avatar
    CGI.unescape(object.user.image.url(:thumb))
  end

  def posts
    object.posts
  end

  def trophy_awards
    object.trophy_awards
  end
end
