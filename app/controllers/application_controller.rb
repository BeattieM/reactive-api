# Base controller for all API endpoints
class ApplicationController < ActionController::API
  include ActionController::Serialization
  
  attr_reader :current_user

  def authenticate_api_user
    find_user_by_doorkeeper_token(doorkeeper_token) if doorkeeper_token
    render_invalid_auth unless @current_user
  end

  def find_user_by_doorkeeper_token(token)
    if (token.expired? || token.revoked?) && @logout != true
      return render_expired_token
    else
      @current_user = User.find_by(id: token.resource_owner_id)
    end
  end

  def render_model_errors(errors_from_model, status)
    @errors = errors_from_model.map { |k, v| OpenStruct.new(field: k.to_s, message: v) }
    render_errors(status)
  end

  def render_item_not_found(item)
    render_field_error(item, 'not found', :not_found)
  end

  def render_field_error(fld, msg, status)
    @errors = [OpenStruct.new(field: fld, message: msg)]
    render_errors(status)
  end

  private

  def render_expired_token
    render_field_error('Token', 'has expired', :unauthorized)
  end

  def render_invalid_auth
    render_field_error('Credentials', 'are invalid', :unauthorized)
  end

  def render_errors(status = :unauthorized)
    render json: { errors: @errors.map { |e| { field: e.field, message: e.message } } }, status: status
  end
end
