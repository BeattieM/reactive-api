# Controller for User specific endpoints
class V1::UsersController < ApplicationController
  include AuthConcerns

  # POST /users
  #
  # Creates a new User
  def create
    user = User.new(user_params)
    return render_model_errors(user.errors, :unprocessable_entity) unless user.save
    @current_user = user
    render json: slice_token(create_doorkeeper_access_token), status: :created
  end

  # POST /users/login
  #
  # Returns or generates a new Doorkeeper Access Token
  def sign_in
    user = User.where(email: params[:email]).first
    return render_invalid_auth unless user && user.valid_password?(params[:password])
    @current_user = user
    render json: slice_token(active_token), status: :ok
  end

  # POST /user/logout
  #
  # Revokes the current user's Doorkeeper Access Token
  def sign_out
    @logout = true
    authenticate_api_user
    @logout = false
    revoke_access if @current_user
    head :no_content
  end

  private

  def user_params
    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    user_params[:email] = user_params[:email].downcase
    user_params
  end

  def active_token
    access_token = find_or_create_doorkeeper_access_token
    create_doorkeeper_access_token if access_token.expired? || access_token.revoked?
    access_token
  end

  def revoke_access
    token = find_most_recent_doorkeeper_access_token
    token.revoke
  end
end
