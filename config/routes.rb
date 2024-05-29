Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, only: [:index]
    resources :invoices, only: [:index]
  end
end
