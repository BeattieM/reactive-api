module AuthConcerns
  extend ActiveSupport::Concern

  def create_doorkeeper_access_token
    Doorkeeper::AccessToken.create(
      resource_owner_id: current_user.id,
      use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?,
      expires_in: Doorkeeper.configuration.access_token_expires_in
    )
  end

  def find_or_create_doorkeeper_access_token
    Doorkeeper::AccessToken.where(
      resource_owner_id: current_user.id,
      expires_in: Doorkeeper.configuration.access_token_expires_in)
      .order(created_at: :desc)
      .first_or_create(
        resource_owner_id: current_user.id,
        use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?,
        expires_in: Doorkeeper.configuration.access_token_expires_in
      )
  end

  def find_most_recent_doorkeeper_access_token
    Doorkeeper::AccessToken.where(
      resource_owner_id: current_user.id,
      expires_in: Doorkeeper.configuration.access_token_expires_in)
      .last
  end

  def slice_token(doorkeeper_token)
    {
      access_token: doorkeeper_token.slice(:token)[:token],
      refresh_token: doorkeeper_token.slice(:refresh_token)[:refresh_token]
    }
  end
end
