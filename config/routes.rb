Rails.application.routes.draw do
  devise_for :users, skip: [ :sessions, :registrations ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  devise_scope :user do
    post "/signup", to: "auth/registrations#create"
    post "/login", to: "auth/sessions#create"
    delete "/logout", to: "auth/sessions#destroy"

    get    "/user_info",   to: "auth/registrations#show"
    put    "/update_user", to: "auth/registrations#update"
    delete "/delete_user", to: "auth/registrations#destroy"
  end
  resources :companies

  # Defines the root path route ("/")
  # root "posts#index"
end
