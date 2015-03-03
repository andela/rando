# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
user = User.where(email: 'ebun@andela.co').first
user.add_role :admin if user

user = User.where(email: 'franklin.ugwu@andela.co').first
user.add_role :admin if user

User.find_each do |user|
  first, last = user.name.split(" ")
  user.update_attributes(first_name: first, last_name: last)
  user.add_role :member
end