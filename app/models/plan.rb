class Plan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  def name_and_price
    "#{self.name} - #{number_to_currency(self.price)}"
  end
end
