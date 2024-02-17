class ShrimpoSerializer < ActiveModel::Serializer
  attributes :title, :rule_pack, :start_at, :end_at, :status, :zip_file_url, :shrimpo_entries, :slug, :emoji
  has_many :shrimpo_entries, embed: :ids, key: :shrimpo_entries, embed_in_root: true, each_serializer: ShrimpoEntrySerializer

  def zip_file_url
  end

  def shrimpo_entries
    object.shrimpo_entries
  end
end
