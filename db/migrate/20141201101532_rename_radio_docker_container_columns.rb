class RenameRadioDockerContainerColumns < ActiveRecord::Migration
  def change
    rename_column :radios, :docker_container_id, :icecast_container_id
    add_column :radios, :liquidsoap_container_id, :string
  end
end
