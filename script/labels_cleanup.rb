Label.find_each do |label|
  downcase_name = label.name.downcase
  dups = Label.where("name ilike ?", "%#{downcase_name}")
  if dups.count > 1
    # delete all except 1
    the_one_true_label = dups.first
    the_one_true_label.update(name: name.downcase)
    dups.pop
    dups.find_each do |dup|
      shows = ScheduledShowLabel.where(label: dup)
      shows.update_all label_id: the_one_true_label.id
      tracks = TrackLabel.where(label: dup)
      tracks.update_all label_id: the_one_true_label.id
    end
    dups.map(&:destroy)
  end
end
