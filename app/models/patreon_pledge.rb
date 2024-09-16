class PatreonPledge < ApplicationRecord
  def tier_name
    # decide tier name from pledge_amount_cents
    "pineapple master"
  end
end
