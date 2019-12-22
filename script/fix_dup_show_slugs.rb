ScheduledShow.where.not(slug: nil).select(:slug).group(:slug).having("count(*) > 1").each do |show|
  ScheduledShow.where(slug: show.slug).find_each do |ss|
    puts "fixing show #{ss.id} with slug #{ss.slug}"
    ss.slug = nil
    ss.save!
    puts "new slug: #{ss.slug}"
  end
end
