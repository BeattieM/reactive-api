Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
  end

  namespace :v1 do
    resources :posts, only: %i[index create update destroy]

    resources :users, only: [:create] do
      collection do
        post 'sign_in', to: 'users#sign_in'
      end
    end

    scope 'user', as: :current_user do
      get '/', to: 'users#show'
      post 'sign_out', to: 'users#sign_out'
    end
  end
end
