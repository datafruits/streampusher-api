class AddIcecastListenerIdToListens < ActiveRecord::Migration
  def change
    add_column :listens, :icecast_listener_id, :integer, null: false
  end
end
