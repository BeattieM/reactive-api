Rails.application.routes.draw do
  scope 'v1' do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
  end

  namespace :v1 do
    resources :posts, only: %i[index create update destroy]
  end
end
