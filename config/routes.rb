Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/', to: 'home#index'

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, only: [:index, :new, :show, :edit, :update, :create]
    resources :invoices, only: %i[index show update]
  end

  resources :merchants, only: %i[show create] do
    resources :dashboard, only: [:index]
    resources :items
    resources :invoices, only: %i[index show update edit]
    resources :invoice_items, only: [:update]
    resources :bulk_discounts, only: [:index, :show]
  end
end
