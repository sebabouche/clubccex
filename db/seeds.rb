# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Session::SignUp.(user: {
  firstname: "Signing",
  lastname: "Up",
  email: "signing@up.com",
  recommenders: [
    {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"},
    {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
  ]})

User::Create::Unconfirmed.(user: {
  firstname: "Unconfirmed",
  lastname: "Unconfirmed",
  email: "unconfirmed@unconfirmed.com"})

User::Create::Unconfirmed::Sleeping.(user: {
  firstname: "Unconfirmed",
  lastname: "Sleeping",
  email: "unconfirmed@sleeping.com"})

User::Create::Confirmed.(user: {
  firstname: "Confirmed",
  lastname: "Confirmed",
  email: "confirmed@confirmed.com"})

User::Create::Confirmed::Sleeping.(user: {
  firstname: "Confirmed",
  lastname: "Sleeping",
  email: "confirmed@sleeping.com"})

User::Create::Confirmed::Admin.(user: {
  firstname: "Admin",
  lastname: "Istrator",
  email: "admin@clubccex.com"})
