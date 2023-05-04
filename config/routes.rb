Rails.application.routes.draw do
  resources :informatiques
  resources :loisirs
  resources :langages
  resources :diplomes
  resources :experiences
  resources :cvs
  resources :categorie_cvs
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post "/connection", to: "users#login"
end