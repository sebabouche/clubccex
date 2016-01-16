# require_dependency "session/operations"

class SessionsController < AnonymousController
  

  def sign_up_form
    form Session::SignUp
  end

  def sign_up
    run Session::SignUp do |op|
      flash[:notice] = "Please log in now!"
      return redirect_to thank_you_path
    end

    render 'sign_up_form'
  end

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

  def operation_model_name # FIXME.
   "FIXME"
  end

end
