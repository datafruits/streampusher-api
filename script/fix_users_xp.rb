User.find(ExperiencePointAward.all.pluck(:user_id).uniq).each do |user|
  user.update experience_points: 0
  ExperiencePointAward.where(user_id: user.id).each do |xp_award|
    xp = user.experience_points + xp_award.amount
    user.update experience_points: xp
    while user.should_level_up?
      if user.should_level_up?
        user.level_up!
      end
    end
  end
end
