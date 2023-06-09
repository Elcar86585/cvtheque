Rails.application.routes.draw do
  resources :entretiens
  resources :favorites
  resources :demand_logins
  resources :comments
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
  get "/ddemande", to: "demand_logins#last"
  get "/notify", to: "demand_logins#notify"
  get "/search", to: "cvs#search"
  get "/cvall", to: "cvs#cvcounter"
  get "/catcounter", to: "categorie_cvs#catCounter"
  get "/usersearch", to: "users#search"
end
