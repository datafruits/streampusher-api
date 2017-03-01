class FillInUserTimeZones < ActiveRecord::Migration[4.2]
  class User < ActiveRecord::Base; end
  def change
    User.find_each do |user|
      user.update_column :time_zone, "UTC"
    end
  end
end
