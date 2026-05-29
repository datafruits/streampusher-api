class TreasureChestSerializer < ActiveModel::Serializer
  attributes :treasure_name, :amount, :treasure_uuid, :username

  def username
    object.user.username
  end
end
