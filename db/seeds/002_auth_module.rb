puts 'Auth module seeder start'

vendor = Vendor.first

20.times do
  User.create!(name: Faker::GameOfThrones.character,
               email: Faker::Internet.email,
               password: 'hackathon',
               vendor: vendor)
end

AuthModule::Permissions.new.refresh
['Vendor', 'Admin', 'Operations', 'Random Role'].each do |role_name|
  role = Role.create!(label: role_name)
  role.permissions = Permission.active
end

User.all.each do |user|
  user.add_role Role.vendor_role
end

puts 'Auth module seeder end'
