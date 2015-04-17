require 'csv'

datafruits = Radio.find_by_name 'datafruits'

CSV.foreach("./scripts/users.csv", headers: true) do |row|
  puts "importing #{row['username']}"
  user = User.new email: row['email'], username: row['username'], encrypted_password: row['encrypted_password'], role: 'dj'
  user.user_radios.build(radio: datafruits)
  user.save(validate: false)
  puts user
  if !user.persisted?
    raise "user not saved"
  end
end
