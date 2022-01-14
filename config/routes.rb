Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'greetings#index'

  devise_for :users

  resources :keywords, only: [:index, :create, :show]

  namespace :api do
    namespace :v1 do
      # OAuth2 Doorkeeper
      use_doorkeeper do
        controllers tokens: 'tokens'
        skip_controllers :authorizations, :applications, :authorized_applications
      end
    end
  end
end
