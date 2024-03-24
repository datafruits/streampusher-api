class ShrimpoSerializer < ActiveModel::Serializer
  attributes :title, :rule_pack, :start_at, :end_at, :status, :zip_file_url, :shrimpo_entries, :slug, :emoji, :cover_art_url, :ended_at, :duration, :username, :user_avatar, :entries_count
  has_many :shrimpo_entries, embed: :ids, key: :shrimpo_entries, embed_in_root: true, each_serializer: ShrimpoEntrySerializer
  has_many :posts, embed: :ids, key: :posts, embed_in_root: true, each_serializer: PostSerializer

  def entries_count
    object.shrimpo_entries.count
  end

  def username
    object.user.username
  end

  def user_avatar
    CGI.unescape(object.user.image.url(:thumb))
  end

  def cover_art_url
    if object.cover_art.present?
      if ::Rails.env != "production"
        path = ::Rails.application.routes.url_helpers.rails_blob_path(object.cover_art, only_path: true)
        "http://localhost:3000#{path}"
      else
        object.cover_art.url
      end
    end
  end

  def zip_file_url
    if object.zip.present?
      if ::Rails.env != "production"
        path = ::Rails.application.routes.url_helpers.rails_blob_path(object.zip, only_path: true, disposition: 'attachment')
        "http://localhost:3000#{path}"
      else
        object.zip.url
      end
    end
  end

  def shrimpo_entries
    object.shrimpo_entries
  end

  def posts
    object.posts
  end
end
