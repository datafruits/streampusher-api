class AddApprovedToHostApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :host_applications, :approved, :boolean, null: false, default: false
  end
end
