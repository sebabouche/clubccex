# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



User::Create::Confirmed::Admin.(user: {
  firstname: "Sébastien",
  lastname: "Nicolaïdis",
  email: "s.nicolaidis@me.com"})

User::Create::Confirmed::Admin.(user: {
  firstname: "Arnaud",
  lastname: "Barbelet",
  email: "a.barbelet@gmail.com"})

User::Create::Confirmed::Admin.(user: {
  firstname: "Matthieu",
  lastname: "Vetter",
  email: "matthieu.vetter@gmail.com"})

User::Create::Confirmed.(user: {
  firstname: "C2",
  lastname: "C2",
  email: "c2@example.com"})

User::Create::Confirmed.(user: {
  firstname: "C3",
  lastname: "C3",
  email: "c3@example.com"})

Session::SignUp.(user: {
  firstname: "C1",
  lastname: "C1",
  email: "c1@example.com",
  recommenders: [
    {"firstname" => "C2", "lastname" => "C2", "email" => "c2@example.com"},
    {"firstname" => "C3", "lastname" => "C3", "email" => "c3@example.com"},
  ]})

User::Create::Confirmed::Sleeping.(user: {
  firstname: "Confirmed",
  lastname: "Sleeping",
  email: "confirmed@sleeping.com"})
