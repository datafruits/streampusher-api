class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.friendly_find id
    return self.friendly.find id.downcase.gsub(/[^0-9a-z\-\s]/i, '').strip.gsub("\s", "-")
  end
end
