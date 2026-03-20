require "sidekiq/web"

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"] || "admin")
  ) & ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"] || "password")
  )
end

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
  resources :categories

  resources :expenses do
    resources :receipts, only: [ :create, :destroy ]
    member do
      post :approve
      post :reject
      post :reimburse
      delete :archive
    end
  end



  mount Sidekiq::Web => "/sidekiq"
  # Defines the root path route ("/")
  # root "posts#index"
end
