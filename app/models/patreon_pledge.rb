class PatreonPledge < ApplicationRecord
  # TODO
  after_create :add_role_to_user

  def tier_mappings
    # FIXME
    # i'm just hardcoding these because i'm lazy as hell
    # but maybe one day we can actually fetch them from the API again
    # if they ever change
   {
     "2707958" => "it's just a website" =>,
     "3525904" => "This is amazing" =>,
     "7252475" => "duckle" =>,
     "2647278" => "Datafruits Premium" =>,
     "3045500" => "emerald fruitizen" =>,
     "2707792" => "golden fruitizard" =>,
     "2985324" => "omnipresent fruit guru K.O.",
   }
  end

  def parsed_json
    valid_json_string = self.json_blob
      .gsub("=>", ": ") # Convert hash rocket `=>` to JSON `:`
      .gsub(/#<ActionController::Parameters (.*?) permitted: false>/, '\1') # Remove ActionController::Parameters wrapper
      .gsub("nil", "null")

    # Parse JSON into a Ruby Hash
    parsed_hash = JSON.parse(valid_json_string)
    parsed_hash
  end

  def tier_name
    tier_id = parsed_json["relationships"]["currently_entitled_tiers"]["data"][0]["id"]
    tier_mappings[tier_id]
  end

  private
  def add_role_to_user
    email = parsed_json["attributes"]["email"]
    user = User.find_by email: email
    # if we can't find the user by the email, will have to assign later manually
    if user.present?
      user.add_role_to_user
      case tier_name
      # TODO
      # when "it's just a website"
      # when "this is amazing"
      when "duckle"
        user.add_role "duckle"
      when "Datafruits Premium"
        user.add_role "supporter"
      when "emerald fruitizen"
        user.add_role "emerald_supporter"
      when "golden fruitizard"
        user.add_role "gold_supporter"
      end
    end
  end
end
