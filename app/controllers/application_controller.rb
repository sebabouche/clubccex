class ApplicationController < ActionController::Base
  layout 'application'

  protect_from_forgery with: :exception

  include Trailblazer::Operation::Controller
  require 'trailblazer/operation/controller/active_record'
  include Trailblazer::Operation::Controller::ActiveRecord

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end

  helper_method :tyrant

  #def process_params!(params)
  #  params.merge!(current_user: tyrant.current_user)
  #end  
end
