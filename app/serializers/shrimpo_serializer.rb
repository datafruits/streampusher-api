class ShrimpoSerializer < ActiveModel::Serializer
  attributes :title, :rule_pack, :start_at, :end_at, :status, :zip_file_url, :shrimpo_entries, :slug

  def zip_file_url
  end

  def shrimpo_entries
    object.shrimpo_entries
  end
end
