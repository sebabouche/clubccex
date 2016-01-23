class ApplicationController < ActionController::Base
  include Trailblazer::Operation::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Trailblazer::NotAuthorizedError, with: :user_not_authorized

  def tyrant
    Tyrant::Session::new(request.env["warden"])
  end
  helper_method :tyrant

  def process_params!(params)
    params.merge!(current_user: tyrant.current_user)
  end

  def user_not_authorized
    flash[:alert] = "Not authorized, my friend."
    redirect_to root_path
  end

  def redirect_to_back_or_default(default = root_url)
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end  
end

