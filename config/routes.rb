Rails.application.routes.draw do
  resources :topics
  resources :facts #do
  post "/add-from-extension" => "facts#add_from_extension"
  # post "/groups/:groupName/discussions-ext" => "discussions#create_from_extension"

    # post "/rephrases" => "rephrases#create"
  # end
  resources :users
  post "/user-search" => "users#search"

  resources :groups, only: [:index, :create, :update] do
	  resources :discussions, only: [:create, :show, :update] do
	  	resources :comments, only: [:create, :index]
      resources :messages, only: [:index, :create]
      patch "/unread-messages-count" => "discussion_unread_messages#update"
	  end	
  end

  resources :interests, only: [:index, :update, :create]

  get "/review" => "review#index"
  post "/review" => "review#create"
  get "/email" => "users#invite"
  # post "users/:email", to: "users#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post "authenticate", to: "authentication#authenticate"
  get "/confirm-email/:token" => "users#confirm_email"

  post "/feedback" => "users#feedback"

  mount ActionCable.server => '/cable'
end
