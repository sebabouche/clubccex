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

1.upto(48) { |x| Event.create(number: x) }

30.times do
  User::Create::Confirmed.(user: {
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email })
end
