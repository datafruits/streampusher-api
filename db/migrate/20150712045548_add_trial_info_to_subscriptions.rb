class AddTrialInfoToSubscriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :subscriptions, :on_trial, :boolean, null: false, default: false
    add_column :subscriptions, :trial_ends_at, :datetime, null: true
  end
end
