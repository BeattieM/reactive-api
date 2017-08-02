# This support package contains modules for authenticaiting
# devise users for request specs.

# This module authenticates users for request specs.#
module AuthenticatedUserRequestHelper
  # Define a method which signs in as a valid user.
  def authenticate_a_user(user = nil)
    user ||= FactoryGirl.create :user

    Doorkeeper::AccessToken.create(
      resource_owner_id: user.id,
      use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?,
      expires_in: Doorkeeper.configuration.access_token_expires_in
    )

    user
  end
end

# Configure these to modules as helpers in the appropriate tests.
RSpec.configure do |config|
  # Include the help for the request specs.
  config.include AuthenticatedUserRequestHelper, type: :controller
end
