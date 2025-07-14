class ChangeTreasureChestNulls < ActiveRecord::Migration[7.0]
  def change
    TreasureChest.where(treasure_uuid: nil).find_each do |tc|
      tc.update! treasure_uuid: SecureRandom.uuid
    end
    change_column_null :treasure_chests, :user_id, false
    change_column_null :treasure_chests, :treasure_uuid, false
    change_column_null :treasure_chests, :treasure_name, false
  end
end
