Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'greetings#index'

  devise_for :users

  resources :keywords, only: [:index, :create, :show]

  namespace :api do
    namespace :v1 do
      resources :keywords, only: [:index, :create, :show]

      # OAuth2 Doorkeeper
      use_doorkeeper do
        controllers tokens: 'tokens'
        skip_controllers :authorizations, :applications, :authorized_applications
      end

      devise_scope :user do
        resources :registrations, only: :create
        resources :passwords, only: :create
      end
    end
  end
end
