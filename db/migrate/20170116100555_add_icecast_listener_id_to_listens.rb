class AddIcecastListenerIdToListens < ActiveRecord::Migration[4.2]
  def change
    add_column :listens, :icecast_listener_id, :integer, null: false
  end
end
