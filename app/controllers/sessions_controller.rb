# require_dependency "session/operations"

class SessionsController < AnonymousController
  

  ### SIGN UP ###
  def sign_up_form
    form Session::SignUp
  end

  def sign_up
    run Session::SignUp do |op|
      return redirect_to thank_you_path
    end

    @form.prepopulate!
    render 'sign_up_form'
  end

  before_filter only: [:sign_up_sleeping_form] do
    Session::IsSignUpable.reject(params) do 
      flash[:notice] = "Vous êtes déjà enregistré(e). Contactez le club si vous rencontrez des problèmes de connexion (contact@clubccex.com)."
      redirect_to root_path
    end
  end
  def sign_up_sleeping_form
    form Session::SignUp::Sleeping
  end

  def sign_up_sleeping
    run Session::SignUp::Sleeping do |op|
      return redirect_to thank_you_path
    end

    render 'sign_up_sleeping_form'
  end

  ### SIGN IN ###
  before_filter only: [:sign_in_form, :sign_in] { redirect_to root_path if tyrant.signed_in? }
  def sign_in_form
    form Session::SignIn
  end

  def sign_in
    run Session::SignIn do |op|
      tyrant.sign_in!(op.model)
      return redirect_to root_path
    end

    render 'sign_in_form'
  end

  def sign_out
    run Session::SignOut do |op|
      tyrant.sign_out!
      redirect_to root_path
    end
  end

  ### WAKE UP ###
  before_filter only: [:wake_up_form] { Session::IsConfirmable.reject(params) { redirect_to(root_path) } }
  def wake_up_form
    form Session::WakeUp
  end

  def wake_up
    run Session::WakeUp do
      flash[:notice] = "Password changed."
      redirect_to sessions_sign_in_form_path and return
    end

    render 'wake_up_form'
  end

  def create_admin
    User::Create::Confirmed::Admin.run(user: {firstname: "Admin", lastname: "User", email: "halo1979@hallo20.com"})  do |op|
      flash[:notice] = "Admin Created."
      return redirect_to root_path
    end
    flash[:error] = "Admin could not be created."
    redirect_to root_path
  end

  def operation_model_name # FIXME.
   "FIXME"
  end

end
