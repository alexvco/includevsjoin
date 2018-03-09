# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


10.times do 
  User.create(name: ('a'..'z').to_a.shuffle[0...8].join, admin: rand(2))
end


10.times do 
  Group.create(name: ('a'..'z').to_a.shuffle[0...8].join)
end

10.times do
  Comment.create(content: ('a'..'z').to_a.shuffle[0...26].join, user_id: rand(10))
end

10.times do 
  Membership.create(user_id: rand(10), group_id: rand(10))
end