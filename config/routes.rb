Rails.application.routes.draw do
  resources :topics
  resources :facts do
    post "/rephrases" => "rephrases#create"
  end
  resources :users
  resources :groups, only: [:index, :create, :update] do
	  resources :discussions, only: [:create, :show] do
	  	resources :comments, only: [:create, :index]
      resources :messages, only: [:index, :create]
      patch "/unread-messages-count" => "discussion_unread_messages#update"
	  end	
  end

  resources :interests, only: [:index, :update, :create]

  get "/review" => "review#index"
  post "/review" => "review#create"
  # post "users/:email", to: "users#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "authenticate", to: "authentication#authenticate"
  mount ActionCable.server => '/cable'
end
