module SessionsHelpers
  def sign_up_user!(firstname = "Sébastien", lastname = "Nico", email = "sebastien@example.com")
    Session::SignUp.(user: {
      firstname: firstname,
      lastname: lastname,
      email: email,
      recommenders: [
        {"firstname" => "Arnaud", "lastname" => "Barb", "email" => "arnaud@example.com"},
        {"firstname" => "Matthieu", "lastname" => "Vett", "email" => "matt@example.com"}
      ]}).model
  end

  def sign_up_and_confirm_user!(firstname = "Sébastien", lastname = "Nico", email = "sebastien@example.com")
    user = sign_up_user!(firstname, lastname, email)
    User::Confirm.(id: user.id)
    confirmation_token = Tyrant::Authenticatable.new(user).confirmation_token
    Session::WakeUp.(
      id: user.id,
      confirmation_token: confirmation_token,
      user: {password: "password", confirm_password: "password"}).model
  end

  def sign_up_sleeping!
    sign_up!
    visit "/sessions/sign_up_sleeping_form/2/"
    fill_in 'user[recommenders_attributes][0][firstname]', with: "Baptiste"
    fill_in 'user[recommenders_attributes][0][lastname]', with: "Auzeau"
    fill_in 'user[recommenders_attributes][0][email]', with: "baptiste@example.com"
    fill_in 'user[recommenders_attributes][1][firstname]', with: "Romain"
    fill_in 'user[recommenders_attributes][1][lastname]', with: "Bastide"
    fill_in 'user[recommenders_attributes][1][email]', with: "romain@example.com"
    click_button 'Envoyer'
  end

  def sign_in_user!(email = "sebastien@example.com", password = "password")
    visit "/"
    fill_in 'session[email]', with: email
    fill_in 'session[password]', with: password
    click_button "Se connecter"
  end

  def sign_in_admin!
    admin = create_admin!
    visit "/"
    fill_in 'session[email]', with: admin.email
    fill_in 'session[password]', with: "password"
    click_button "Se connecter"
  end

  def create_confirmed_sleeping!
    User::Create::Confirmed::Sleeping.(
      user: {
        firstname: "Paul",
        lastname: "Duf",
        email: "paul@example.com" }).model
  end

  def create_user!
    # Not using operation (rogue kid!) to speed up persistence
    User.create(
      firstname: Faker::Name.first_name,
      lastname: Faker::Name.last_name,
      email: Faker::Internet.email,
      confirmed: 1,
      sleeping: 0)
  end

  def create_admin!
    User::Create::Confirmed::Admin.(user: {firstname: "Admin", lastname: "Strator", email: "admin@example.com"}).model
  end

end
