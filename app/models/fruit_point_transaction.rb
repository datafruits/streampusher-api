class FruitPointTransaction < ApplicationRecord
  enum type: [:uploaded_show, :scheduled_show, :lemoner_fruit_button_pressed, :bananay_fruit_button_pressed, :strawbur_fruit_button_pressed, :orangey_fruit_button_pressed, :cabbage_fruit_button_pressed]
  belongs_to :user
end
