class LoggedController< ApplicationController
  layout 'logged'

  before_action { redirect_to sessions_sign_in_form_path if !tyrant.signed_in? }
  before_action :new_post

  def index
  end

  private

  def new_post
    @new_post ||= form Post::Create
  end
end
