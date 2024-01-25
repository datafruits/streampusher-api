class FakeUser < User
  self.table_name = :users
  has_attached_file :image, styles: { :thumb => "150x150#", :medium => "250x250#" },
    path: ":attachment/:style/:basename.:extension"
end

FakeUser.find_each do |fake_user|
   User.find(fake_user.id).update(image: fake_user.image)
   # fake_user.image.destroy
end
