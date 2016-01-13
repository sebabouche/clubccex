class ApplicationController < ActionController::Base
  layout 'application'

  protect_from_forgery with: :exception

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  helper_method :tyrant
end
