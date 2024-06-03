Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/', to: 'home#index'

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, only: [:index, :new, :show, :edit, :update, :create]
    resources :invoices, only: %i[index show]
  end

  resources :merchants, only: [:show, :create] do
    resources :dashboard, only: [:index]
    resources :items
    resources :invoices, only: [:index]
  end
end
