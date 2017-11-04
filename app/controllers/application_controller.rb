class ApplicationController < ActionController::API
  include Knock::Authenticable

  protected

  def authorize_as_admin
    head :unauthorized unless !current_user.nil? && current_user.is_admin?
  end
end
