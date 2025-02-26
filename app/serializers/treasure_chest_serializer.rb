class TreasureChestSerializer < ActiveModel::Serializer
  attributes :treasure_name, :amount, :treasure_uid, :treasure_uuid, :username

  def username
    object.user.username
  end

  def treasure_uuid
    object.treasure_uid
  end
end
