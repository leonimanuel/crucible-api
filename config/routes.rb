Rails.application.routes.draw do
  resources :topics
  resources :facts
  resources :users
  resources :groups, only: [:index]
  resources :discussions, only: [:create]
  # post "users/:email", to: "users#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "authenticate", to: "authentication#authenticate"
end
