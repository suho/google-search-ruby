Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'greetings#index'

  devise_for :users

  resources :keywords, only: [:index, :create, :show]
end
