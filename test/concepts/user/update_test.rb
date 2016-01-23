class UpdateTest < MiniTest::Spec
  let (:user) { User::Create::Confirmed.(user: {
    firstname: "Sébastien",
    lastname: "Nicolaïdis",
    email: "s.nicolaidis@me.com"}).model }
  let (:other_user) { User::Create::Confirmed.(user: {
    firstname: "Matthieu",
    lastname: "Vetter",
    email: "mattvett@gmail.com"}).model }

  describe "Users" do
    it "persists valid" do
      res, op = User::Update.run(id: user.id, user: {
        firstname: "Fille",
        lastname: "Courseuse",
        email: "fille@cce.com",
        nickname: "Nickname",
        maidenname: "Maiden",
        company: "Company",
        occupation: "Occupation",
        events: [
          {"number" => "32"},
          {"number" => "33"}
        ],
        city: "Paris",
        admin: true
      },
      current_user: user)

      res.must_equal true

      model = op.model
      model.firstname.must_equal "Fille"
      model.lastname.must_equal "Courseuse"
      model.email.must_equal "fille@cce.com"
      model.nickname.must_equal "Nickname"
      model.maidenname.must_equal "Maiden"
      model.company.must_equal "Company"
      model.occupation.must_equal "Occupation"
      model.events[0].number.must_equal 32
      model.events[1].number.must_equal 33
      model.city.must_equal "Paris"
      model.admin.wont_equal true
    end
    
    it "is invalid if other user" do
      assert_raises Trailblazer::NotAuthorizedError do
        User::Update.run(
          id: user.id, 
          user: {firstname: "Other"},
          current_user: other_user)
      end
    end
  end
end
