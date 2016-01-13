require 'test_helper'

class SessionSignUpTest < MiniTest::Spec
  describe "SignUp" do

    let(:valid_user) { Session::SignUp.(user: {
      firstname: "Sébastien",
      lastname: "Nicolaïdis",
      email: "s.nicolaidis@me.com",
      recommenders: [
        {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
        {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
      ]}).model }

    it "renders form" do
      form = Session::SignUp.present({}).contract
      form.prepopulate!

      form.recommenders.size.must_equal (2)
      form.recommenders[0].email.must_equal nil
      form.recommenders[1].email.must_equal nil
    end


    describe "is valid and persists" do
      it "with valid user infos" do
        valid_user.persisted?.must_equal true
        valid_user.firstname.must_equal 'Sébastien'
        valid_user.lastname.must_equal 'Nicolaïdis'
        valid_user.email.must_equal 's.nicolaidis@me.com'
      end

      it "with an existing recommender" do
        test_idis = User.create(firstname: "Test", lastname: "Idis", email: "test.idis@icloud.com")

        op = Session::SignUp.(user: {
        firstname: "Sébastien",
        lastname: "Nicolaïdis",
        email: "s.nicolaidis@me.com",
        recommenders: [
          {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
        ]})

        op.model.recommenders[0].attributes.slice("id", "email").must_equal "id" => test_idis.id, "email" => "test.idis@icloud.com"
      end
      
      it "with existing recommender and doesn't change recommender's firstname" do
        test_idis = User.create(firstname: "Test", lastname: "Idis", email: "test.idis@icloud.com")
        
        users_before = User.count

        op = Session::SignUp.(user: {
        firstname: "Sébastien",
        lastname: "Nicolaïdis",
        email: "s.nicolaidis@me.com",
        recommenders: [
          {"firstname" => "Tesssssst", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"}
        ]})

        User.count.must_equal users_before + 2
        op.model.recommenders[0].attributes.slice("id", "firstname", "email").must_equal "id" => test_idis.id, "firstname" => test_idis.firstname, "email" => test_idis.email
      end
    end


    describe "is invalid" do
      it "without a firstname" do
        res, op = Session::SignUp.run(user: {firstname: "", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        res.must_equal false
        op.contract.errors.to_s.must_match "firstname"
      end

      it "without a lastname" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        res.must_equal false
        op.contract.errors.to_s.must_match "lastname"
      end

      it "without an email" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        res.must_equal false
        op.contract.errors.to_s.must_match "email"
      end

      it "without a valid email" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "blah",
                              recommenders: [
                                {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})

        res.must_equal false
        op.contract.errors.to_s.must_match "email"
      end

      it "with not enough recommenders" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.comé"})

        res.must_equal false
        op.contract.errors.to_s.must_match "user"
      end

      it "with an invalid recommender" do
        res, op = Session::SignUp.run(user: {firstname: "Sébastien", lastname: "Nicolaïdis", email: "s.nicolaidis@me.com",
                              recommenders: [
                                {"firstname" => "", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
                                {"firstname" => "Hack", "lastname" => "Idis", "email" => "hack.idis@icloud.com"} ]})


        res.must_equal false
        op.contract.errors.to_s.must_match "recommenders.firstname"

        form = op.contract
        form.prepopulate!

        form.recommenders[0].firstname.must_equal ""
        form.recommenders[1].firstname.must_equal "Hack"
      end
    end


    it "is invalid if the recommenders are the same" do
      res, op = Session::SignUp.run(user: {
        firstname: "Sébastien",
        lastname: "Nicolaïdis",
        email: "s.nicolaidis@me.com",
        recommenders: [
          {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"},
          {"firstname" => "Test", "lastname" => "Idis", "email" => "test.idis@icloud.com"}
        ]})

      res.must_equal false
      op.contract.errors.to_s.must_equal "{:user=>[\"Vous devez spécifier deux recommandations différentes\"]}"
    end
  end
end
