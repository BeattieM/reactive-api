# Base controller for all API endpoints
class ApplicationController < ActionController::API
  include ActionController::Serialization

  private

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
