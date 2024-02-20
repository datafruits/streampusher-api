class ShrimpoEntrySerializer < ActiveModel::Serializer
  attributes :title, :audio_file_url, :username, :user_avatar, :slug, :user_role, :cdn_url, :shrimpo_emoji, :shrimpo_slug, :created_at, :previous_shrimpo_entry_slug, :next_shrimpo_entry_slug, :total_score, :ranking
  belongs_to :shrimpo
  has_many :shrimpo_votes, embed: :ids, key: :shrimpo_votes, embed_in_root: true, each_serializer: ShrimpoVoteSerializer

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
end
