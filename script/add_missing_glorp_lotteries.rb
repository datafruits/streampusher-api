glop_awards = ExperiencePointAward
  .where(source_id: nil, award_type: ["gloppy", "glorppy"])

glop_awards.find_each do |glop|
  lottery = GlorpLottery.create! user: glop.user, amount: glop.amount
  glop.update source: lottery
end
