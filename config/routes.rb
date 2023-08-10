Rails.application.routes.draw do
  default_url_options :host => "www.usuls.com"
  get '/' => 'counters#index', :constraints => { :subdomain => 'hits' }
  root to: 'pages#home'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users do
    resource :profile # Is this still used?
  end
  resources :pets
  resources :conversations do
    resources :messages
  end
  get 'verification', to: 'users#verification'
  get 'about', to: 'pages#about'
  resources :contacts, only: :create
  get 'contact-us', to: 'contacts#new', as: 'new_contact'
  resources :reports
  get 'rules', to: 'pages#rules'

  # An SVG masquerading as a PNG
  get '/images/:petname.png', to: 'counters#image', format: :svg
  get '/kaleidoscopes/:id.gif', to:'kaleidoscopes#show', format: :svg
end
