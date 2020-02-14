class AddHomepageUrlToHostApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :host_applications, :homepage_url, :string
  end
end
