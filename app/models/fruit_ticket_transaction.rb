class FruitTicketTransaction < ApplicationRecord
  belongs_to :from_user # null means the website gave you fruit tickets
  belongs_to :to_user # null means bought something from the website

  # how do you get fruit tickets
  #   - people listen to your show
  #   - 1 fruit ticket for every listener?
  #   - 1 fruit ticket per archive playback
  #   - donate to patreon/ampled
  #   - commit on github
  #
  enum transaction_type: [
    # receiving
    :show_listeners_count,
    :archive_playback,
    :supporter_membership,
    :code_contribution,
    # purchase
    :fruit_animation,
    :profile_sticker
  ]
end
