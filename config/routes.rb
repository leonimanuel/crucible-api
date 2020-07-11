Rails.application.routes.draw do
  resources :topics
  resources :facts
  resources :users
  resources :groups, only: [:index, :create] do
	  resources :discussions, only: [:create, :show] do
	  	resources :comments, only: [:create, :index]
      resources :messages, only: [:index, :create]
      patch "/unread-messages-count" => "discussion_unread_messages#update"
	  end	
  end

  get "/review" => "review#index"
  # post "users/:email", to: "users#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "authenticate", to: "authentication#authenticate"
  mount ActionCable.server => '/cable'
end
