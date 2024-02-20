class ShrimpoSerializer < ActiveModel::Serializer
  attributes :title, :rule_pack, :start_at, :end_at, :status, :zip_file_url, :shrimpo_entries, :slug, :emoji, :cover_art_url, :ended_at
  has_many :shrimpo_entries, embed: :ids, key: :shrimpo_entries, embed_in_root: true, each_serializer: ShrimpoEntrySerializer

  def cover_art_url
  end

  def zip_file_url
    if object.zip.present?
      if ::Rails.env != "production"
        ::Rails.application.routes.url_helpers.rails_blob_path(object.zip, only_path: true, disposition: 'attachment')
      else
        object.zip.url
      end
    end
  end

  def shrimpo_entries
    object.shrimpo_entries
  end
end
