Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/', to: 'home#index'

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, only: [:index]
    resources :invoices, only: %i[index show]
  end

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, only: %i[index show edit update]
    resources :invoices, only: [:index]
  end
end
