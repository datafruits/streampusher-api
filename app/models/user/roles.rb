module User::Roles
  extend ActiveSupport::Concern
  VALID_ROLES = %w[admin dj manager listener vj supporter strawberry lemon orange cabbage banana watermelon]

  included do
    validate :valid_role
  end

  VALID_ROLES.each do |r|
    define_method "#{r}?" do
      has_role? r
    end
  end

  def has_role?(r)
    roles.include?(r)
  end

  def roles
    self.role.to_s.split(' ')
  end

  def add_role new_role
    if self.role.blank?
      self.role = ""
    end
    unless self.role.include? new_role
      self.role << " #{new_role}"
      self.save
      Notification.create notification_type: "#{new_role}_badge_award", user: self, send_to_chat: true
      ActiveSupport::Notifications.instrument 'user.badge_award', username: self.username, badge: new_role
    end
  end

  private

  def valid_role
    if !role.to_s.blank?
      self.roles.each do |r|
        if !VALID_ROLES.include?(r)
          errors.add :role, "is not a valid role."
        end
      end
    end
  end
end
