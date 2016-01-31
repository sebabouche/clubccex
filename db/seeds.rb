user = User::Create::Confirmed::Admin.(user: {
  firstname: "Sébastien",
  lastname: "Nicolaïdis",
  email: "s.nicolaidis@me.com"}).model

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

Category::Create.(current_user: user, category: {
  name: "Jobs",
  priority: 1,
  icon: "graduation-cap",
  library: "fa" })

Category::Create.(current_user: user, category: {
  name: "Biz dev",
  priority: 2,
  icon: "rocket",
  library: "fa" })

Category::Create.(current_user: user, category: {
  name: "Partenariats",
  priority: 3,
  icon: "hand-peace-o",
  library: "fa" })

Category::Create.(current_user: user, category: {
  name: "Recherche d'info",
  priority: 4,
  icon: "search",
  library: "fa" })

User::Create::Confirmed::Sleeping.(user: {
  firstname: "Confirmed",
  lastname: "Sleeping",
  email: "confirmed@sleeping.com"})

1.upto(48) { |x| Event.create(number: x) }

20.times do
  User::Create::Confirmed.(user: {
    firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name,
    email: Faker::Internet.email })
end

20.times do
  user = User.all.shuffle.first
  Post::Create.(
    current_user: user,
    post: {
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      category_id: rand(Category.count - 1)+1,
      user_id: user.id
    })
end

50.times do
  user = User.all.shuffle.first
  post = Post.all.shuffle.first
  Comment::Create.(
    current_user: user,
    comment: {
      body: Faker::Lorem.sentence,
      post: post
    })
end
