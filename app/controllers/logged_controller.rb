class LoggedController< ApplicationController
  layout 'logged'

  before_filter { redirect_to sessions_sign_in_form_path if !tyrant.signed_in? }
  def index
  end
end
