# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email:'cmmdc@foxmail.com',nickname:'cmm', password: 'cmadmin',password_confirmation: 'cmadmin',admin: true)

20.times do
  name = [*('a'..'z')].sample(6).join
  User.create(email:"#{name}@foxmail.com",nickname:"#{name}", password: '123456',password_confirmation: '123456',admin: false)
end
