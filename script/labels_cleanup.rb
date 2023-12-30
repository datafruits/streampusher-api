Label.find_each do |label|
  downcase_name = label.name.downcase
  dups = Label.where("name ilike ?", "%#{downcase_name}")
  if dups.count > 1
    # delete all except 1
    dups.pop
    dups.map(&:destroy)
  end
  dups.first.update(name: name.downcase)
end
