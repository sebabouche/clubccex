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

Category::Create.(current_user: user, category: {
  name: "Random",
  priority: 5,
  icon: "wechat",
  library: "fa" })

1.upto(48) { |x| Event.create(number: x) }
