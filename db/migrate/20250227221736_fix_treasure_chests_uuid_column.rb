class FixTreasureChestsUuidColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :treasure_chests, :treasure_uid, :treasure_uuid

    add_index :treasure_chests, :treasure_uuid, unique: true
  end
end
