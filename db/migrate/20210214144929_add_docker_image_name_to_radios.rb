class AddDockerImageNameToRadios < ActiveRecord::Migration[5.0]
  def change
    add_column :radios, :docker_image_name, :string, null: false, default: ""
  end
end
